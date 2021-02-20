class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://github.com/shirok/Gauche/releases/download/release0_9_10/Gauche-0.9.10.tgz"
  sha256 "0f39df1daec56680b542211b085179cb22e8220405dae15d9d745c56a63a2532"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
    regex(/href=.*?Gauche[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "39e73449557616fcdbe0da0e6795b16fdc35a17618e5a9c26db5acb247a5c588"
    sha256 big_sur:       "946cf4fb5df28115150e9e8fef530885dea4ea78a141340b76a3696813c5ceb5"
    sha256 catalina:      "3242db5cccc130802f125d27c51b447b1f52a43d2a4d8a4819f52b71d88d08e5"
    sha256 mojave:        "c278ec5a5c34957a9e75b386aad28736a4a64864c4f1a156486e6b4959e4aed5"
  end

  depends_on "mbedtls"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--enable-multibyte=utf-8"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gosh -V")
    assert_match "Gauche scheme shell, version #{version}", output
  end
end
