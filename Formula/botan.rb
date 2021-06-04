class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.18.1.tar.xz"
  sha256 "f8c7b46222a857168a754a5cc329bb780504122b270018dda5304c98db28ae29"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 arm64_big_sur: "49d7c6c498d9eeb8d5d8be5b1dfe36107c499bb651df544028e9fec7cdac814d"
    sha256 big_sur:       "c95c511ab524fe403fb6ca322e1e4b1075d010e1ed6fe8523589297157ef1209"
    sha256 catalina:      "de7d2bcd91abe81ef297b2134e1aa4bd622f5c9764614e3af0fc04b4a39ad75a"
    sha256 mojave:        "281575e69fdacaa33127379de2da8d4a5e1951fd98da54ed448655cb959d8149"
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
