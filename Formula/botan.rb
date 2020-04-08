class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.14.0.tar.xz"
  sha256 "0c10f12b424a40ee19bde00292098e201d7498535c062d8d5b586d07861a54b5"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "75f313ac637a72bc4d9bae3da9be62bc77c266f3fbe5802093c65085f1f02dea" => :catalina
    sha256 "97fbb92e2f170233b142a71cc5781dd0166f802ca87f070b416e746803d9ba3f" => :mojave
    sha256 "a1476f2cb331dbca755c3edb274cafe50c6d7fd6e5504d1e1990a98905accda1" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on :macos # Due to Python 2
  depends_on "openssl@1.1"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
