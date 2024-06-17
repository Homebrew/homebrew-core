class BotanAT2 < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.19.4.tar.xz"
  sha256 "5a3a88ef6433e97bcab0efa1ed60c6197e4ada9d9d30bc1c47437bf89b97f276"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "release-2"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "474b35ff0b5f6181037c3abbfcdb2e18bbd6f36984319c9a2a0d8b0bf644adbe"
    sha256 arm64_ventura:  "95984c9e9d4253c0e2a5aa62025f114b889e7eb20c87db78f0d18da716ef3c76"
    sha256 arm64_monterey: "95827c9faccd5b1c3ebf7b4b2fc1ca1698bd91eb429cfb202b341fb1836ece8c"
    sha256 sonoma:         "ed5cccfcfa2bb1a7449a44fc8cf1c9649e060c890d07423a3c8357a5e59a134f"
    sha256 ventura:        "c02d656cf9e53ebbe300ccfee5bdcecf5229938491208c37dda8255a28419202"
    sha256 monterey:       "f83cdd76d128db1c88a5ffde722c5fa78815cee57f954423b074c22632c2cb03"
    sha256 x86_64_linux:   "4cb4c1a3e7e7d08a7782780ffc5f84df3b6259776205fc97fbb511dc5bc3bddd"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "python@3.12"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def python3
    which("python3.12")
  end

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --with-zlib
      --with-bzip2
      --with-sqlite3
    ]

    system python3, "configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write shell_output("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
