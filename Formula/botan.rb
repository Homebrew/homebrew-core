class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.7.0.tgz"
  sha256 "e42df91556317588c6ca0e41bf796f9bd5ec5c70e0668e6c97c608c697c24a90"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "6caab4a7ebb6d816dcb5b7ca6ef1b8496fe6591d48f08322d5c83a9aa0957b5a" => :mojave
    sha256 "c68dce2f0c95d9992f46a0481c5067f2f73cb5a78593e5075334704751a9205c" => :high_sierra
    sha256 "f23e22e379f69bab321a47a7afe17a10153f94a3a9f5107544f71c63172f3c64" => :sierra
    sha256 "693252ff477a8c5ce0a0703538682d90a2bb0e63e52237d279c8fa7a7863a2a8" => :el_capitan
  end

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

    system "./configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write Utils.popen_read("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
