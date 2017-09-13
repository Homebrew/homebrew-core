class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.2.0.tgz"
  sha256 "c794db2ec46f6ff88f37ae76825f0c258f07880b865b6707b26acfcc4567b824"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "81a51ae9befa03e97b84206d7244cae9a2763f68fa7bd7f989b8e070f73731c9" => :sierra
    sha256 "8d611e2fdb0e848193b363331fd668f4edae4139ff58d31c73a657e90cd0974f" => :el_capitan
    sha256 "9b0bd3d8914a59621186e6147190f3068dffd36fb0822ef7b836c60acedb3bd4" => :yosemite
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
