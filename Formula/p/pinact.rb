class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.9.2.tar.gz"
  sha256 "ea47eefa985476b8fe3cafc814d636242fc51897f35328af3809665a0c3841ca"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "531e6b7a272081b6010a8f8aa509dd960384ee5a6e3970b828940baf235434bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "531e6b7a272081b6010a8f8aa509dd960384ee5a6e3970b828940baf235434bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "531e6b7a272081b6010a8f8aa509dd960384ee5a6e3970b828940baf235434bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b47629b93804a000e752b166bd61bf9791b8ee8c59fbc3ea3e7482e13c0a1392"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0860429ab7fdd7efa940b42ec820811d685ec7e14816346ffcfaf8ed69badbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f05561e97a18803ca46871b1c507958d6bf010da1776be5cd7c0f67c7e5df708"
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
