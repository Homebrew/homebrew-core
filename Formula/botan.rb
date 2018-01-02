class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.3.0.tgz"
  sha256 "39f970fee5986a4c3e425030aef50ac284da18596c004d1a9cce7688c4e6d47c"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "2c20b3c39fb0be0a165edaca579c643688ee3c985fe70380b738242650f6acf6" => :high_sierra
    sha256 "a0700e24788e9d267e8af25792865fdaa24bd99425122c7bd0158fcd7156779e" => :sierra
    sha256 "7c5621270316444d975d6da333a9b867734e2c67a4b044df621e4bbeb3ce330b" => :el_capitan
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

    args << "--with-debug" << "--debug-mode" if build.with? "debug"

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
