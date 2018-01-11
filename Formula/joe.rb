class Joe < Formula
  desc "Joe's Own Editor (JOE)"
  homepage "https://joe-editor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/joe-editor/JOE%20sources/joe-4.6/joe-4.6.tar.gz"
  sha256 "495a0a61f26404070fe8a719d80406dc7f337623788e445b92a9f6de512ab9de"

  bottle do
    sha256 "760c0a06be2796ab446f917d4bd806adb7433e2ae5d00d5429406f67aebece77" => :high_sierra
    sha256 "bd6a3920d921b24b9e4c414e70512381849f64fcc4d93c2d2fcc60d4c79b7180" => :sierra
    sha256 "73f46c197aa85834ea639d93ea02740deeb18c31bb0ddfc2f6400164c6dde566" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Joe's Own Editor v#{version}", shell_output("TERM=tty #{bin}/joe -help")
  end
end
