class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://github.com/lcn2/calc/archive/refs/tags/v2.17.0.0.tar.gz"
  sha256 "aeea09ed7c5b5a7c1913e4eff5bc49cd4bad0b987da8b259792293416b986525"
  license "LGPL-2.1-or-later"
  head "https://github.com/lcn2/calc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "8c3e00cad2b6248ba7ef6979b6cb14936029c7f1433eba2edb401113c217596c"
    sha256 arm64_sequoia: "6c2015c6e285c4f78bb011c5dd0ff257eeebdb74b05e037475c7f0ec7ef0902b"
    sha256 arm64_sonoma:  "53465dff12e74fb188d96c7d3cd975b57a8569c551eccc1843b804a5ef73ba03"
    sha256 sonoma:        "6b452caa0141901021e0e5d3937019dbbb7584490f5d4efca98c050d7f92c95d"
    sha256 arm64_linux:   "5b0f5a4d0f5b89d83ef5725126673529869bb472d58b60f1b1bd46224b04c8f2"
    sha256 x86_64_linux:  "8a7b0de4ae90f6cb33a6b2dbec0bce240219a9832bbe8a0678af92c1fc7374ff"
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
