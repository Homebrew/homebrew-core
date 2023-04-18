class Libeatmydata < Formula
  desc "LD_PRELOAD library and wrapper to transparently disable fsync and related calls"
  homepage "https://www.flamingspork.com/projects/libeatmydata/"
  url "https://github.com/stewartsmith/libeatmydata/releases/download/v131/libeatmydata-131.tar.gz"
  sha256 "cf18a8c52138a38541be3478af446c06048108729d7e18476492d62d54baabc4"
  license "GPL-3.0-or-later"
  head "https://github.com/stewartsmith/libeatmydata.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "de3355a75858f6920204fff4ad1e6eb7b38052a7bf07dae93328042742ee8cb0"
    sha256 cellar: :any,                 arm64_monterey: "5aeff8a0e8b2c0a31cc32263aaa7a7ab6bbbd6f67eb580fb936afabdb0aa68bf"
    sha256 cellar: :any,                 arm64_big_sur:  "e9483db0ccbd0655be7cc8460d15ee7859d413e3193de6757226d89e6ab939fa"
    sha256 cellar: :any,                 ventura:        "a04cdcab93139d5f4c67c0d8dc1ec8edd3ce018196f479be4e42788d366d13c8"
    sha256 cellar: :any,                 monterey:       "04224ec4469d4c4ec5a076067d375c705cd0aab2fda326aa4d99dec11d88a62e"
    sha256 cellar: :any,                 big_sur:        "d41935844ac5a0c0ab0f3970d16f8172534cb0cf6c63b0ecb7532e7730d79cf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e475757576e6590c75990086fd97f7582028e9f44af02bbca011c1e7e7d3099"
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
