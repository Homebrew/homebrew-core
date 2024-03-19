class Libeatmydata < Formula
  desc "LD_PRELOAD library and wrapper to transparently disable fsync and related calls"
  homepage "https://www.flamingspork.com/projects/libeatmydata/"
  license "GPL-3.0-or-later"
  head "https://github.com/stewartsmith/libeatmydata.git", branch: "master"

  stable do
    url "https://github.com/stewartsmith/libeatmydata/releases/download/v131/libeatmydata-131.tar.gz"
    sha256 "cf18a8c52138a38541be3478af446c06048108729d7e18476492d62d54baabc4"

    # Fix for https://github.com/Homebrew/homebrew-core/issues/136873.
    # Remove with `stable`` block on next release.
    patch do
      url "https://github.com/stewartsmith/libeatmydata/commit/ae89d0916c0ddd06f4ce7f2b37eaccf8dd543591.patch?full_index=1"
      sha256 "8bf4249f3df141fa321c8c64af4f4442bc23bdfb108e2cf73c22e68a3a71ae15"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "31d27501006e2d40b9d48c6d004e46ad2c2dab4709c7bb49cdac96f81e8f5984"
    sha256 cellar: :any,                 arm64_ventura:  "ba431c20d2cfdca496b982172a5c1cfa54019e722d39d68452da7ba777b90364"
    sha256 cellar: :any,                 arm64_monterey: "e85eba783c02da67dbba76f16de831769b13ce6fdaccf94e0404567b2a0646f4"
    sha256 cellar: :any,                 arm64_big_sur:  "a0d61b1323d5efdcb7ad0d9a5c92e0196d75e0cc10ffa53acd65813dbfe5e152"
    sha256 cellar: :any,                 sonoma:         "888117a3bf6892fa4276968ae237f45e1323629fb35608b98efd1a8c4d902f9a"
    sha256 cellar: :any,                 ventura:        "03d011ca0e5c1a324b8ba45a10ddcb07fba2128ce0ae352a3c4c652ea060f347"
    sha256 cellar: :any,                 monterey:       "c424091120ea1d287a7ac95cdbf2620cdc0adf8e251e79cbeb8b4326b800ae24"
    sha256 cellar: :any,                 big_sur:        "4d2a2ee043f16c6215d03d286f27395cf40ed7d2de56bee098b36cad579dbe0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "108aec33bd43ad8bb056cbe840019a5ec42f0f16a99c3b40d0ce8c5d891f0249"
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
