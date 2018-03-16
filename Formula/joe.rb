class Joe < Formula
  desc "Joe's Own Editor (JOE)"
  homepage "https://joe-editor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/joe-editor/JOE%20sources/joe-4.6/joe-4.6.tar.gz"
  sha256 "495a0a61f26404070fe8a719d80406dc7f337623788e445b92a9f6de512ab9de"

  bottle do
    sha256 "02c1d1372565747bc21abe3b28ea7b3f2461068041e2d67037a9c1cbce12779d" => :high_sierra
    sha256 "f97df02a316a9e137e3391f42ff1118f67cd051008ef92c030fe54b5948a29bb" => :sierra
    sha256 "1d02a0b1f7df9846b0472bb3a5ea69aece88007fed4b32843318caa41cae3f9d" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Joe's Own Editor v#{version}", shell_output("TERM=tty #{bin}/joe -help")
  end
end
