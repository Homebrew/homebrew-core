class Libfaketime < Formula
  desc "Report faked system time to programs"
  homepage "https://github.com/wolfcw/libfaketime"
  url "https://github.com/wolfcw/libfaketime/archive/v0.9.7.tar.gz"
  sha256 "4d65f368b2d53ee2f93a25d5e9541ce27357f2b95e5e5afff210e0805042811e"
  head "https://github.com/wolfcw/libfaketime.git"

  bottle do
    sha256 "99f78789ba8ee314d2358531a106d245c327a2248d7b59712493543806604eae" => :high_sierra
    sha256 "3fc5f61a8d50f7586cc18d269263fa95481bd741ac1756f2f55b5932e5a01ce5" => :sierra
    sha256 "0b792c716c6e8ba9db928b0c4dc4ab2dc474eb12da529186ba4475f5fba73169" => :el_capitan
  end

  depends_on :macos => :lion

  def install
    system "make", "-C", "src", "-f", "Makefile.OSX", "PREFIX=#{prefix}"
    bin.install "src/faketime"
    (lib/"faketime").install "src/libfaketime.1.dylib"
    man1.install "man/faketime.1"
  end
end
