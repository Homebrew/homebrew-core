class Libquicktime < Formula
  desc "Library for reading and writing quicktime files"
  homepage "https://libquicktime.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libquicktime/libquicktime/1.2.4/libquicktime-1.2.4.tar.gz"
  sha256 "1c53359c33b31347b4d7b00d3611463fe5e942cae3ec0fefe0d2fd413fd47368"
  license "LGPL-2.1-or-later"
  revision 5

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "5f0134430e06269fcef851532addb2e837cf60ef41c44ad3dd9155c1d5df6b50"
    sha256 arm64_sequoia: "aa6f973349d6fa176f4078a6f7c7f256ecad756d6f0cdc82b7bb9f43063cb5fa"
    sha256 arm64_sonoma:  "9a6054232de1d537092af3dfe35a2cdf19bddcc8afd7d55728201cd59a554615"
    sha256 sonoma:        "70a9ec36aaed0263037bfd108e0da0c092432f6861d0ff17fb8730de135c3f70"
    sha256 arm64_linux:   "370790e912c171ed805ef864de5823c80c849a8e2169547a6fb4eb3bb06990f4"
    sha256 x86_64_linux:  "9ec46f428d1f6724ff976a745df2d3e967f5e4158e5782d345501b0269392929"
  end

  depends_on "pkgconf" => :build

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix CVE-2016-2399. Applied upstream on March 6th 2017.
  # Also, fixes from upstream for CVE-2017-9122 through CVE-2017-9128, applied
  # by Debian since 30 Jun 2017.
  patch do
    url "https://deb.debian.org/debian/pool/main/libq/libquicktime/libquicktime_1.2.4-12.debian.tar.xz"
    sha256 "e5b5fa3ec8391b92554d04528568d04ea9eb5145835e0c246eac7961c891a91a"
    apply "patches/CVE-2016-2399.patch"
    apply "patches/CVE-2017-9122_et_al.patch"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm64?

    system "./configure", "--enable-gpl",
                          "--without-doxygen",
                          "--without-gtk",
                          "--without-x",
                          *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.m4a")
    output = shell_output("#{bin}/qtinfo #{fixture} 2>&1")
    assert_match "length 1536 samples, compressor mp4a", output
    assert_path_exists testpath/".libquicktime_codecs"
  end
end
