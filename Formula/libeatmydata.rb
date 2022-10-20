class Libeatmydata < Formula
  desc "LD_PRELOAD library and wrapper to transparently disable fsync and related calls"
  homepage "https://www.flamingspork.com/projects/libeatmydata/"
  url "https://github.com/stewartsmith/libeatmydata/releases/download/v130/libeatmydata-130.tar.gz"
  sha256 "48731cd7e612ff73fd6339378fbbff38dd3bcf6c243593b0d9773ca0051541c0"
  license "GPL-3.0-or-later"
  head "https://github.com/stewartsmith/libeatmydata.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3f5017d7e37be50a9252f81e9022687522a7e3c1609b67444ad1ca057ad264dc"
    sha256 cellar: :any,                 arm64_big_sur:  "b9c56d489dc16c1a3beb5cdd985146be80175f4fb867c9a961889ffa0a90f554"
    sha256 cellar: :any,                 monterey:       "c8737d93760861f482f5d837c1a1895982b91fcb3f39641ecb4debb20aba9fad"
    sha256 cellar: :any,                 big_sur:        "8add447ca5e24dc7ca18806cd05e1c331524103d6386b7042990a53c48cedec4"
    sha256 cellar: :any,                 catalina:       "751364e952669da3326acb14d76957fce4b6208e6fbe3ce74bdeb14da8f0f600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d69ac9bb30a2fb57e23265d0c21a40e70416c3db78ae2f6304e6b837978bd72c"
  end

  depends_on "autoconf"         => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake"         => :build
  depends_on "libtool"          => :build

  depends_on "coreutils"

  on_linux do
    depends_on "strace" => :test
  end

  def install
    # macOS does not support `readlink -f` as used by the `eatmydata` shell wrapper script
    inreplace "eatmydata.sh.in", "readlink", "#{Formula["coreutils"].opt_bin}/greadlink" if OS.mac?

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args,
                          "--disable-option-checking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"eatmydata", "sync"
    return if OS.mac?

    output = shell_output("#{bin}/eatmydata #{Formula["strace"].opt_bin}/strace sync 2>&1")
    refute_match(/^[a-z]*sync/, output)
    refute_match("O_SYNC", output)
    assert_match(" exited with 0 ", output)
  end
end
