class Libeatmydata < Formula
  desc "Because fsync() should be a no-op"
  homepage "https://www.flamingspork.com/projects/libeatmydata/"
  url "https://github.com/stewartsmith/libeatmydata/releases/download/v130/libeatmydata-130.tar.gz"
  sha256 "48731cd7e612ff73fd6339378fbbff38dd3bcf6c243593b0d9773ca0051541c0"
  license "GPL-3.0-or-later"
  head "https://github.com/stewartsmith/libeatmydata.git", branch: "master"

  depends_on "autoconf"         => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake"         => :build
  depends_on "libtool"          => :build

  on_linux do
    depends_on "strace" => :test
  end

  def install
    system "autoreconf", "-vfi"
    system "./configure", *std_configure_args,
                          "--disable-option-checking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "#{bin}/eatmydata", "sync"
    if OS.linux?
      test_match = "grep -E '(^[a-z]*sync|O_SYNC| exited with 0 )'|wc -l"
      # Verify via strace(1) that sync(1) just exits under eatmydata without sync(2) being called.
      assert_match "1\n",
        shell_output("#{bin}/eatmydata #{Formula["strace"].opt_bin}/strace sync 2>&1|#{test_match}")
    end
  end
end
