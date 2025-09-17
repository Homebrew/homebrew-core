class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://codeberg.org/jbruchon/jdupes"
  url "https://codeberg.org/jbruchon/jdupes/archive/v1.30.0.tar.gz"
  sha256 "9cf4727526d988cee62705f29f53c21765838302713ed6e6c0b29ac117c66af5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "992652f273eba2749ac9d3bc898cb9b56d60585adb209a1f835bcded32e2cf6d"
    sha256 cellar: :any,                 arm64_sequoia: "bf13fca52de31046be8d384b328ffc06a7469bdb3c4ac2395124af859f963df8"
    sha256 cellar: :any,                 arm64_sonoma:  "275595001b2b92d7c703c19fd47bb4b1a5b79f3b269320e2b67ef77c08629488"
    sha256 cellar: :any,                 arm64_ventura: "c61d231a14741496d9d08b4eaad8a21fa8c25d459797214b26e71ac216b04151"
    sha256 cellar: :any,                 sonoma:        "a293555bd6f8f5a3a7d18ddc2c08d7e6910dcf2bc30eb3d252583058cfea54dd"
    sha256 cellar: :any,                 ventura:       "44de35b0123ddb92175ba7d2e033bbbedf6578a00b47675b76f9449c00d8fc3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fb72e297067bcd4c13172fc5a9663b3928083ae382ae48f3e58a3b4de1f6e94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37a40291a140fae56f732ede2171ba24d957b5f1ac983a716fda7726585a5495"
  end

  depends_on "libjodycode"

  def install
    # error: no member named 'st_mtim' in 'struct stat'
    inreplace "filestat.c" do |s|
      s.gsub! "st_mtim.tv_sec", "st_mtime"
      s.gsub! "st_atim.tv_sec", "st_atime"
    end

    system "make", "ENABLE_DEDUPE=1"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zero-match .").strip.split("\n").sort
    assert_equal ["a", "b"], dupes
  end
end
