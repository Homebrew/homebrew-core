class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "a58de86006fef4bb92d2a5a7d46e9de2a671815cdd5cfdad12161435ceb9163c"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbd3e7f6363481f223a8744eac40777d7a04db60b56f90935b70132bb3a192a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbd3e7f6363481f223a8744eac40777d7a04db60b56f90935b70132bb3a192a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbd3e7f6363481f223a8744eac40777d7a04db60b56f90935b70132bb3a192a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c737184fca23f4b4b724025019a47201bb8a9a27cbfb2f739b7ea97465415fb7"
    sha256 cellar: :any_skip_relocation, ventura:       "c737184fca23f4b4b724025019a47201bb8a9a27cbfb2f739b7ea97465415fb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4a3d176cb8cb7d635529695f69f9c480550b13fbf3a4a9ae1ffafaf501284ae"
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
