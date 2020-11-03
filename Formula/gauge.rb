class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/v1.1.5.tar.gz"
  sha256 "b11767c95b03a6a59bb6570e4b9c210979d40c560ac65de009b60cdc4742eda9"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f53e79aaae0ab172d32ee5a3ecf6c34e58ecd54d5cb7e84e32c62e8af52e56a7" => :catalina
    sha256 "5826571c92e733869fddd8983169578e068d0f260cfc4196c84e53775847d252" => :mojave
    sha256 "2aa0079b48e0d2b4f263ac55183c69f476c71e4e03521ecae1dd499f9de867ef" => :high_sierra
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
