class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/v1.1.6.tar.gz"
  sha256 "ae826943badd5377d15e247d722c4dc8ea6ecfd5c54cdec93b90f4a5136ea00b"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1305b11432745324f0dc743477fa2ebf3de1b65d4b8991428efcee7c87bc53a" => :big_sur
    sha256 "f395799bcee7d019db8c425efac14197da0627d8fa776a1a9c3341ce3944c76b" => :catalina
    sha256 "179ea1f964d984ae8a4bce8a281a0cbebbdebda62040242bb1782487fd8e78f8" => :mojave
    sha256 "18a8e818061258898ab408e2711339d7559e1ac948f02f2901736e4e1e587348" => :high_sierra
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
