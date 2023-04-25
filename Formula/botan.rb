class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-3.0.0.tar.xz"
  sha256 "5da552e00fa1c047a90c22eb5f0247ec27e7432b68b78e10a7ce0955269ccad7"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0638e55c5840c54d22f4d2bc346b70fb52cea1d28ea567ea49b9337a32c94452"
    sha256 arm64_monterey: "217cfcf31670c98e77203c6f9bad5f16dc5f2432cb8620ec50ebd2e7c110361e"
    sha256 arm64_big_sur:  "28f4b38a5ae6813302c846252c72ead5c7a63612ef951cf21e858fd26eb13d08"
    sha256 ventura:        "bddea6bc8adad44734dc3223fb86414a396b07d3d13c8139c0306bc326893f73"
    sha256 monterey:       "859aab2d6e57dcbd9671d61b4f6e6bba8b4c3ab3a51d4e8eb55359623aef64a1"
    sha256 big_sur:        "9695bfc605fc5db484b42948ee0b93fe49efd2502fc2ec0cae8bd96b58c53071"
    sha256 x86_64_linux:   "a01b782a7d5c8fb3ac8caa546fa18bca15e2b52440fce3241f4a314e7a81deb6"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1315
  end

  fails_with :clang do
    build 1315
    cause "requires Xcode 13.3"
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1315

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --with-zlib
      --with-bzip2
      --with-sqlite3
    ]

    system "python3.11", "configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write shell_output("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
