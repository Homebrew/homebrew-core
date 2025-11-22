class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.4.4.tar.gz"
  sha256 "c03657c8fa66a9910d1f4047453f4a414dfd2d0cf4e1e6ba14ac5cd0940e1031"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "152ffbe1ac62f2f73f2b5a6f6dea6b137cc3aa14d1cb03a55d5a7e878cf0886e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "152ffbe1ac62f2f73f2b5a6f6dea6b137cc3aa14d1cb03a55d5a7e878cf0886e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "152ffbe1ac62f2f73f2b5a6f6dea6b137cc3aa14d1cb03a55d5a7e878cf0886e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bea329ab9ce14646a70e6e6d810f964ef47a9ae3de025c7c0da13a739f9f1f9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f683bdbfbb20419de8a5acb1f76a418399b956e3859c1bbcf440c1d9a301570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec806c407458e549102267ad58ed7d79a971a924434ded4ff9603aa4ab13550e"
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
