class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.9.0.tgz"
  sha256 "305564352334dd63ae63db039077d96ae52dfa57a3248871081719b6a9f2d119"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "254a3808f9924a3e1daee51697234911d35d0d0b188ad33a9e3caea39083fc0b" => :mojave
    sha256 "16ef82ba1f86ccc877d773b8baf06139d89721b85285f34c7539a824de6d67f0" => :high_sierra
    sha256 "3190ec5c9f0d790edecb5996a7d675cd92bc7268e076bca5bdb88f358c4b706c" => :sierra
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
