class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.11.0.tar.xz"
  sha256 "f7874da2aeb8c018fd77df40b2137879bf90b66f5589490c991e83fb3e8094be"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "55abedd7f11bd8e778be3e841c225854ebff3f6bb50907f9011d84d48bf487f6" => :mojave
    sha256 "488635ef973781ccd7d796fca009d387580a99a375fe356d6f7e161c35c9bdff" => :high_sierra
    sha256 "cf4a6a75863dfdf7ce4e9e82c81e5e6bcf11246d9eeca2e9eb5b2a4bcee9804a" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

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
