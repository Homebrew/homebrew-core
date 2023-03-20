class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.14.1.5/calc-2.14.1.5.tar.bz2"
  sha256 "6cf69c62710905d42c20ff99f03fce0ec93211cbe1800cb7adae306ac60ca3a0"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "b67d1ea7d51a3eee7819f538d14940fa4b538c8798363b87debd94308a8cf737"
    sha256 arm64_monterey: "12caf544edff5a8890551637a0d0654e5818cd30c535e704dce66fb2d7865f98"
    sha256 arm64_big_sur:  "d754bb41c0b08e1c8d11aa0c3522969f44ee4d51c62a04601238ffecbd7a950e"
    sha256 ventura:        "e2e04c53b3d47ae6069d93f140b136a7ce9cde732b98fc2c550edb7f86877ffc"
    sha256 monterey:       "f5cec7c3da9094acdad4ccaedd4285ab267365d719081a35a7303059aa522abb"
    sha256 big_sur:        "2ce3e91f40996260512c547abd26d139803422a7173179aa77184eb101a60c52"
    sha256 x86_64_linux:   "4a356195218b1b84dccfe919c737c8c45c68f509f0c5b865263c62413225a201"
  end

  depends_on "readline"

  on_linux do
    depends_on "util-linux" # for `col`
  end

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
    args << "INCDIR=#{MacOS.sdk_path}/usr/include" if OS.mac?
    system "make", "install", *args

    libexec.install "#{bin}/cscript"
  end

  test do
    assert_equal "11", shell_output("#{bin}/calc 0xA + 1").strip
  end
end
