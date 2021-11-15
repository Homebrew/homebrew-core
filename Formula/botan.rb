class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.18.2.tar.xz"
  sha256 "541a3b13f1b9d30f977c6c1ae4c7bfdfda763cda6e44de807369dce79f42307e"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "850adbef4b6df09cd0ccbe6488be7af07ca39eaa64579fefe025cd2e6f92c088"
    sha256 arm64_big_sur:  "75e3663e0e99d0ef40a8a62d5f19b738b20f6024845b9f29fc355851a1f382a9"
    sha256 monterey:       "d22f82dbd0196654270ed1d41e0f4894a6130bab963b9e8f7f44a1c1bbf2db69"
    sha256 big_sur:        "53c1d23a7a5bcfda1378d970e6e3140a6f8721c84b92f87c417e01f3fb225124"
    sha256 catalina:       "f934561950c879723f6fde7fb0a6973c7777c869b1dd54012674c99baf8b9584"
    sha256 x86_64_linux:   "941492434980b6730375a8b6e5dec25a4781243740d3d532644a521a89a7ab31"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

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

    system "python3", "configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write shell_output("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
