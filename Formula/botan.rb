class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.2.0.tgz"
  sha256 "c794db2ec46f6ff88f37ae76825f0c258f07880b865b6707b26acfcc4567b824"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "b40addf39ec157733de0b941ddea7c2b91af994b18c28565ccf307d141d9a9b4" => :sierra
    sha256 "5b3337a48e4ffb9d3134d776af7e265e9979903d7ba7a9507aca38708ed41918" => :el_capitan
    sha256 "b5209d8069b0b3832be573a3109b63347cea6e8be90f01546cf0915755fd8c5b" => :yosemite
  end

  option "with-debug", "Enable debug build of Botan"

  deprecated_option "enable-debug" => "with-debug"

  depends_on "pkg-config" => :build
  depends_on "openssl"

  needs :cxx11

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --cpu=#{MacOS.preferred_arch}
      --cc=#{ENV.compiler}
      --os=darwin
      --with-openssl
      --with-zlib
      --with-bzip2
    ]

    args << "--enable-debug" if build.with? "debug"

    system "./configure.py", *args
    # A hack to force them use our CFLAGS. MACH_OPT is empty in the Makefile
    # but used for each call to cc/ld.
    system "make", "install", "MACH_OPT=#{ENV.cflags}"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write Utils.popen_read("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
