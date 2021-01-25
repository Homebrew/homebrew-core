class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.17.3.tar.xz"
  sha256 "79123b654445a4abba486e09a431788545c708237382a3e765664c9f55b03b88"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "347cf202acade4b9f59a4fdb6eb3558556fff55629d10fdd38d728071783fb3c" => :big_sur
    sha256 "eb4bfb2daf7cc0dffd1e545b1b474d22ee183ae41e508ad32511c4a691caac97" => :arm64_big_sur
    sha256 "6a66ebc16aef639262f951c7ec0df47002b704dab8736128be69cc9aeefe73ff" => :catalina
    sha256 "60143efcc59467a036924c1518a38a5b0d1497b4fe2c3f4d9d7894f0cecda50a" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --cc=#{ENV.compiler}
      --os=darwin
      --with-zlib
      --with-bzip2
      --with-sqlite3
      --with-python-versions=3.9
    ]

    system "./configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write shell_output("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
