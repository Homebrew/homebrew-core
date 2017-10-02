class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.3.0.tgz"
  sha256 "39f970fee5986a4c3e425030aef50ac284da18596c004d1a9cce7688c4e6d47c"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "bc4346cbaa61f13229fd03e415bb82f7863c63d51066e89f9810601b5e405c94" => :high_sierra
    sha256 "81a51ae9befa03e97b84206d7244cae9a2763f68fa7bd7f989b8e070f73731c9" => :sierra
    sha256 "8d611e2fdb0e848193b363331fd668f4edae4139ff58d31c73a657e90cd0974f" => :el_capitan
    sha256 "9b0bd3d8914a59621186e6147190f3068dffd36fb0822ef7b836c60acedb3bd4" => :yosemite
  end

  option "with-debug", "Enable debug build of Botan"

  deprecated_option "enable-debug" => "with-debug"

  depends_on "pkg-config" => :build
  depends_on "openssl"

  needs :cxx11

  # Fix build failure "error: no type named 'free' in namespace 'std'"
  # Upstream PR from 3 Oct 2017 "Add missing cstdlib include to openssl_rsa.cpp"
  if DevelopmentTools.clang_build_version < 900
    patch do
      url "https://github.com/randombit/botan/pull/1233.patch?full_index=1"
      sha256 "5ac83570d650d06cedb75e85a08287e5c62055dd1f159cede8a9b4b34b280600"
    end
  end

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
