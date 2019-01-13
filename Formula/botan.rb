class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.9.0.tgz"
  sha256 "305564352334dd63ae63db039077d96ae52dfa57a3248871081719b6a9f2d119"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "76acfd7da8c68b14bbd6eab8c023779656ba8b6e63728239ea841801f923e1fc" => :mojave
    sha256 "7613f1ed4ed336ba1fde3a1469f3f286ebc8005cc8f73c7e41d8c146b729ea82" => :high_sierra
    sha256 "5686536b81aea251723b8f05cf14cda6c3d5f89b46e61a35b524ae61b49761f5" => :sierra
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
