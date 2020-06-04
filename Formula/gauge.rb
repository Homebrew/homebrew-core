class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v1.1.1.tar.gz"
  sha256 "b136727d0ed114ab18d9d380e1ff70ad70e60b56bbacf854be2aeddc9b20044a"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df517fd16fb94885cb0d8ab3988b0b1bb6e6633c0fe0b2c37f7f228bd78ad890" => :catalina
    sha256 "00f2995af67532b08b500619df0bac14b31937a0d0cf20cfc3f5822b8e9c9dcf" => :mojave
    sha256 "f20d136d7eb8c5304aad9924435618a4f99f641955758c1f10b91f9a29c2d3eb" => :high_sierra
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

    system("#{bin}/gauge install")
    assert_predicate testpath/".gauge/plugins", :exist?

    system("#{bin}/gauge config check_updates false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
