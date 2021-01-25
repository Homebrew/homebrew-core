class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.12.7.1/calc-2.12.7.1.tar.bz2"
  sha256 "eb1dc5dd680019e30264109167e20539fe9ac869049d8b1639781a51d1dea84c"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    sha256 "79b3844caf8d7e0bdca720aa2c8c5668c4df580e62544c418bbd8058b98906a3" => :big_sur
    sha256 "9c88838b026adfc769accb5c8f51f1cf80b88d8b2d9a5621c5df0833b71bd026" => :arm64_big_sur
    sha256 "d78863a41409a2e3eaee0b8e4c5eb21a84ee28f1c3f8a27545d6e1f3fe3ae213" => :catalina
    sha256 "1b4e5456d4965f8b74c120590070f74896c1fca85c8aa30354ffe519c1755600" => :mojave
    sha256 "7614247fc707caf03a96e302ab2e1324f6a3609cfd1cdd7c6389bca77511ff18" => :high_sierra
    sha256 "c31e4ac4a08ff6f1803cfcbe2d90a2634737ed69f4c38538f7ba77fc6a3e6728" => :sierra
  end

  depends_on "readline"

  def install
    ENV.deparallelize

    ENV["EXTRA_CFLAGS"] = ENV.cflags
    ENV["EXTRA_LDFLAGS"] = ENV.ldflags

    args = [
      "BINDIR=#{bin}",
      "LIBDIR=#{lib}",
      "MANDIR=#{man1}",
      "CALC_INCDIR=#{include}/calc",
      "CALC_SHAREDIR=#{pkgshare}",
      "USE_READLINE=-DUSE_READLINE",
      "READLINE_LIB=-L#{Formula["readline"].opt_lib} -lreadline",
      "READLINE_EXTRAS=-lhistory -lncurses",
    ]
    on_macos do
      args << "INCDIR=#{MacOS.sdk_path}/usr/include"
    end
    system "make", "install", *args

    libexec.install "#{bin}/cscript"
  end

  test do
    assert_equal "11", shell_output("#{bin}/calc 0xA + 1").strip
  end
end
