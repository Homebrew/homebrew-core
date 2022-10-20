class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.19.2.tar.xz"
  sha256 "3af5f17615c6b5cd8b832d269fb6cb4d54ec64f9eb09ddbf1add5093941b4d75"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "91f84899529b23eea7ea860e557efd155d1274560ba4eff24e80ea7672e3a622"
    sha256 arm64_big_sur:  "c5c5ed5e8597f9206bb357704f615b4386db2b152db1ee892e0183a460a2c191"
    sha256 monterey:       "8b6e3b4073987eb8fbfb371426a04d600e1b96c9c913517f757d35e33c17bc75"
    sha256 big_sur:        "7e6c40b8711f2ce0738b571039db09ae5f8417355839a3afc090661e39b7f976"
    sha256 catalina:       "841b8fdebbec1c9b960e2a075642f88e9ac2eb5185130477b6ee69abe91363d3"
    sha256 x86_64_linux:   "0ccf263cab90ff456586e5935f0d9f8cee11cb469c17023c02704b8d9a007cc8"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --with-zlib
      --with-bzip2
      --with-sqlite3
    ]

    system "python3.10", "configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write shell_output("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
