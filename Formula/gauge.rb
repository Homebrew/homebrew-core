class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/v1.3.1.tar.gz"
  sha256 "811d5ece672550574d8ca12d4ddf75e1c4fa4bc0ee2e4205d706e2831479d0a2"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "571362c12c48900fc53a8e898f2cf4c7fdca02ed20808e456a91235691936dbc"
    sha256 cellar: :any_skip_relocation, big_sur:       "005cbc0be81d61a78109cb9987403f07b3e70bfc298f1427b167c23f73b137d9"
    sha256 cellar: :any_skip_relocation, catalina:      "4ae99ffca72f63f41097fa089d5a530df6d0768717126f42d906703542265fcd"
    sha256 cellar: :any_skip_relocation, mojave:        "d264f669c99b83305f195d9532f88c3588eb85f591b40b0253c07ac460a9bf61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33f427b92d86c373cfd84586d41b1782264db5b2c6397e8178f61eac9a67eab0"
  end

  depends_on "go" => :build

  # remove in next release
  patch do
    url "https://github.com/getgauge/gauge/commit/68ab64f1684e541e148458c1bd6f3c4525897b46.patch?full_index=1"
    sha256 "796bfdcf8c689b824de186cafe9ac3e90e5dc87a4481a57612e01f803f9510c0"
  end

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
