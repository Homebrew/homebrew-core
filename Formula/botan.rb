class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.14.0.tar.xz"
  sha256 "0c10f12b424a40ee19bde00292098e201d7498535c062d8d5b586d07861a54b5"
  revision 1
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "46bb4b5b34e77193b2762f962046ac19be20bf0315f30a91fe849ade416cc872" => :catalina
    sha256 "08935e82d8e4adbe9b6792f8a5022780dc143a73ce18fdf9238ef570b7088c8e" => :mojave
    sha256 "ea545d6eeafec1b0021b5b4a021e11afa8a16ebad2ea1a02c1a8b3460c91a7e5" => :high_sierra
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
