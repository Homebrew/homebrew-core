class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "0182d53d6e5894c534dbce6d897a300329268c6137c8bdd7ac6f9e6a0ec60e7b"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60fc63199bd1ea9ad4c353e242549a64a1d9f83852202bc5245ba46a5138a03e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0bbe4082133fdcbd845fab5d7038fd279163b4fc6992d5d32e4f045515cd6dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39536cbdb44db86956f3363a2d7720239c904e227eb1d2f41ae5c1a695922d8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "d58523e01729a6d4833f6d0b0b9e55f171d18a8dbe5a8516d6a741a88b2f3c11"
    sha256 cellar: :any_skip_relocation, ventura:        "242e71f1714f99d30e4f6bcd80bc227908fdc2f47f9c86b89e6519c5fd9db9b1"
    sha256 cellar: :any_skip_relocation, monterey:       "77b79d3cb5453d42b12fdf7cc1617d36756b8b8fa8af06f28d670362a8a95d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b2dbb8f55d27d7856d760a3784071010cc739dcd62d484a66c7866a5e5feaa5"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
  end

  test do
    (testpath/"manifest.json").write <<~EOS
      {
        "Plugins": [
          "html-report"
        ]
      }
    EOS

    system("#{bin}/gauge", "install")
    assert_predicate testpath/".gauge/plugins", :exist?

    system("#{bin}/gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
