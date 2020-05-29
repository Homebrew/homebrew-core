class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v1.0.9.tar.gz"
  sha256 "e3897d96eb581b89815e5a5d7aaf7e3baa49b4efa500624290743a53e06752de"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "51f82b71c70bca6bbbb26c26d4e5757b294ebd8aa7dd67c01563e059681c73fb" => :catalina
    sha256 "d1fbb4d76fb5a5eacf77cac57cae90954bebd1b4ae83ba05ee7134c9c27d7061" => :mojave
    sha256 "42f5f8f1b221e7fa4c83b4b04cd9c058d338d40f2bae77a5eee356a5772f3a85" => :high_sierra
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
