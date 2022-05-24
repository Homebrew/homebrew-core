class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.19.1.tar.xz"
  sha256 "e26e00cfefda64082afdd540d3c537924f645d6a674afed2cd171005deff5560"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "3b274b0f6b3ff9f1dd2b0e01044c6273edc1e4ea64f375450feefedf4277cbda"
    sha256 arm64_big_sur:  "b93af3781f11f0ae2e862a65fdcd6f2497178a17406970d977a134a512d52b82"
    sha256 monterey:       "69e5d8157383a8ce0bc035d382aec8c631ad8541d0a82dd88570304bbe60c0d3"
    sha256 big_sur:        "63ab627567339771b9207e273fe49b0714a874c12c3f1fd09c30d10489a4cdda"
    sha256 catalina:       "e1850cb0be9128f03e28a1c1aced67a54bf976579ccb9f00c2b555ccdb97fb20"
    sha256 x86_64_linux:   "35b42a1e38a7ea35ed7d14921822e91b22f1275e511096ed1507145ef20b6800"
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
