class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "199149e6b379786d7786948ccaae62b72453f83e9de9ccabf30d2c6a743f8b9c"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bdf965f7a4bc4bfd89d7c1995af30af894e9b80a5910e962eba87717099d6db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bdf965f7a4bc4bfd89d7c1995af30af894e9b80a5910e962eba87717099d6db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8bdf965f7a4bc4bfd89d7c1995af30af894e9b80a5910e962eba87717099d6db"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4d53e1ca383291b6d79560e9248ede6250632939fc79fa3a73e4462abe70dc9"
    sha256 cellar: :any_skip_relocation, ventura:       "a4d53e1ca383291b6d79560e9248ede6250632939fc79fa3a73e4462abe70dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eadb0836df3c77553f7f94ce2e07861e09b4c285c3ad79e8fae5fb3208ce6133"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pinact"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pinact --version")

    (testpath/"action.yml").write <<~YAML
      name: CI

      on: push

      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v3
            - run: npm install && npm test
    YAML

    system bin/"pinact", "run", "action.yml"

    assert_match(%r{.*?actions/checkout@[a-f0-9]{40}}, (testpath/"action.yml").read)
  end
end
