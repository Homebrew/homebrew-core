class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.11.0.tar.xz"
  sha256 "f7874da2aeb8c018fd77df40b2137879bf90b66f5589490c991e83fb3e8094be"
  revision 1
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "f5a85f91c7f2b59ce8dd5344d2b92c29bc23d48f73b926249998ce3db8ccac2e" => :catalina
    sha256 "2feb4965ddb22f39b381f287ec86b51d752d6372ce09061323f0de2784aad913" => :mojave
    sha256 "39fd93ccbbcc9facce634ea568875b16bd3dc14e91b129575a65b8441af70289" => :high_sierra
    sha256 "26a88637571802493479451b59aa3f101a545d4c35d00be583d87dab2845b825" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

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
