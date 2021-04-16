class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/v1.1.8.tar.gz"
  sha256 "3f2ad1c4684083f9f4eaa468dd56c066d888c132ae9f64a84e2cb2f9d7f88527"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a29e0c11060da450aaf074d452121274694a8e54a630948364d3043f565fc612"
    sha256 cellar: :any_skip_relocation, big_sur:       "2e8521b5b97bc35acd028f2a7fcc432975e1db1d8f7afeeaf2b7bd1d2a24a36b"
    sha256 cellar: :any_skip_relocation, catalina:      "1555013193fb810920986aa9ac6897526a6a88ff29dc2ad9130b61d00aceee4a"
    sha256 cellar: :any_skip_relocation, mojave:        "78b8dc7847cbdd69081f3cf7456ddc0a156fc9b5a6166510f3a6e351165ca6d3"
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
