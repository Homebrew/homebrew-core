class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/v1.3.3.tar.gz"
  sha256 "c599f4c734dc125b38ff1559987fb8d6ce285c650b909b31a84e27399ea0c15c"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "81884a878b76b1c09bab8adbca6548aba40cdc1ea65f5c826ed28560345135a1"
    sha256 cellar: :any_skip_relocation, big_sur:       "aadf40951be3277c2ddd808866b4e917db93dc81e92889eceb1a9260a67bc8df"
    sha256 cellar: :any_skip_relocation, catalina:      "998d2288299f24fa24500020164e57702b0242f39d5203c2595867c6de310a28"
    sha256 cellar: :any_skip_relocation, mojave:        "820b15a2c99f17a1e1769e48504ea746d3fcf68a1cf9efee7a34b1501609503f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f695cc25af482c7e6bd0d6b56e81254125546f880b9abf14ebf6eca77263e6b"
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
