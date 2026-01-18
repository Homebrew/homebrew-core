class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "38450696aa0636fd99bb3167826def0dd701447ba25e155fb33adb14238502e3"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c859e7ba328645efcfebbed360439d1f76e3af33c9c5343932e7d2c4391a80be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c859e7ba328645efcfebbed360439d1f76e3af33c9c5343932e7d2c4391a80be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c859e7ba328645efcfebbed360439d1f76e3af33c9c5343932e7d2c4391a80be"
    sha256 cellar: :any_skip_relocation, sonoma:        "975f51a34d1cebed17606f189940c15de8c432426c0461ba229a65623bfd4748"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f86386c0a3dde22941fa8e84c2f5b5d0dcfdcde2a1cbc759b8275c064393980a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0bf9b71185b6d640db8550e8cdcf375007cf154a6bf2109da9a077bdf47841d"
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
