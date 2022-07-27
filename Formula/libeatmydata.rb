class Libeatmydata < Formula
  desc "LD_PRELOAD library and wrapper to transparently disable fsync and related calls"
  homepage "https://www.flamingspork.com/projects/libeatmydata/"
  url "https://github.com/stewartsmith/libeatmydata/releases/download/v130/libeatmydata-130.tar.gz"
  sha256 "48731cd7e612ff73fd6339378fbbff38dd3bcf6c243593b0d9773ca0051541c0"
  license "GPL-3.0-or-later"
  head "https://github.com/stewartsmith/libeatmydata.git", branch: "master"

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
