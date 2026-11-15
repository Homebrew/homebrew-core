class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://github.com/lcn2/calc/archive/refs/tags/v2.17.0.2.tar.gz"
  sha256 "12471c2c23ae6b8a010be7472ef58e877a94022bd2e8c172cb60bede98b6417f"
  license "LGPL-2.1-or-later"
  head "https://github.com/lcn2/calc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "0edf5361bf3a7a3e59c5cf28cb131be9d56404567909df0ac5d8ba6f1a30db74"
    sha256 arm64_tahoe:       "2b97b124467e1165ac167933d6c4c8da8ba8bb41affba09d02ecd7cbabe0030a"
    sha256 arm64_sequoia:     "3dc9dfbf237fd68855b2f611bf671054fbdd38fb78b9d357ecc5792c4d0f8ee8"
    sha256 arm64_linux:       "045ffa26795a0462d71f3538e3caa7285f4709b2f69bd75a189c3aa04141697d"
    sha256 x86_64_linux:      "7f75a8453e4f35233aefc1d1541a584fe8baa5741229c9eff9bc860176bbc623"
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
      "READLINE_LIB=-L#{formula_opt_lib("readline")} -lreadline",
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
