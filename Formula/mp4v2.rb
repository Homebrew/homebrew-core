class Mp4v2 < Formula
  desc "Read, create, and modify MP4 files"
  homepage "https://code.google.com/archive/p/mp4v2/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/mp4v2/mp4v2-2.0.0.tar.bz2"
  sha256 "0319b9a60b667cf10ee0ec7505eb7bdc0a2e21ca7a93db96ec5bd758e3428338"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "b2409e2699d496947970212bf0e05c042349c9aa213e72ce364dc1db049fb240"
    sha256 cellar: :any,                 arm64_big_sur:  "b5c86440ce97fa8500c4d474c8cc8eb17a48bd3db3724f6ce0a6a3dc6a38cfa3"
    sha256 cellar: :any,                 monterey:       "f4422f0cc3290e7a00dfa48044cd78dc78b3de0c02293ba4d51fd0c358e31c5d"
    sha256 cellar: :any,                 big_sur:        "8a15f36160b80d4bf578a0a61f09e6f80b7fa4f0b15443ce1682346e9fed0a65"
    sha256 cellar: :any,                 catalina:       "bf2838fe1bf196c40546bfb7a5800bce710aaf55305a05b719d07d9de2e5b24e"
    sha256 cellar: :any,                 mojave:         "bd4c8e435216cbfc4ed60030e1cd4135156643f8befa1477061c1e59292394bb"
    sha256 cellar: :any,                 high_sierra:    "359eecfb160a0d31975961933b50c7ba512891aedd053e3e9153edba1da364c3"
    sha256 cellar: :any,                 sierra:         "6cab2b32c845f6d54cdb8d64c558126cec39c27fb77a92f204bb8abda1c0ccfa"
    sha256 cellar: :any,                 el_capitan:     "52d299e61126db288d73a3e6e8b40c3eff25af1c7498c4a74787dce2dda02e9a"
    sha256 cellar: :any,                 yosemite:       "14ca4b71690959d461d41b4338be70005de4553566996677f973094c1a56c3fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db1423d53c90cc7fd29bc2f138e8a3503d38d3358d3bab5b885f67703a22ccc8"
  end

  conflicts_with "bento4",
    because: "both install `mp4extract` and `mp4info` binaries"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    system "make", "install-man"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mp4art --version")
  end
end
