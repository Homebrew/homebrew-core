class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/v1.4.1.tar.gz"
  sha256 "833d8d8b395b566ee94ed957dd2a9564b9a11eabe709338db02c1c8c0ee3b637"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5165749a147ed65996a1221d8733460595ab69f20a405bfe55287409228c4ab8"
    sha256 cellar: :any_skip_relocation, big_sur:       "d77649529e3eedb986426dd72f417b5421f9a4c091fa59f6cbbcd8349b045ec8"
    sha256 cellar: :any_skip_relocation, catalina:      "0b1890691d0f690daef611f56c0070cd9e66987050288a65f5c31a54f804c91f"
    sha256 cellar: :any_skip_relocation, mojave:        "4e131abff679c1298094f48b53471da2544d07e3a5c56ba3f12bb98729207afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3efd218935491c84506dca3faba86e47e411c2ed2b048cee3ceca1a71b39387"
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
