class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-3.2.0.tar.xz"
  sha256 "049c847835fcf6ef3a9e206b33de05dd38999c325e247482772a5598d9e5ece3"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "bb6f2d3eb693d5b692b64f30296765a24ff93d53e284d322c630dde2422249b5"
    sha256 arm64_ventura:  "01bac65450b2e718000e0c5412a1c404b12451187cc9ce5782496deeffd100f5"
    sha256 arm64_monterey: "a2145a83102be0793df0d1f125f2ee5d94b58be251c4a6130bda25a4d19d4455"
    sha256 sonoma:         "2adb9e029d4f155308114f14499a707f999f0c369e07a38de5a750059b69133c"
    sha256 ventura:        "3144838597286774c9089edd77193d340f0a568defd97cb2a37281825706297b"
    sha256 monterey:       "9eecd69953d77fca52e7a7cbe7ae4ae7ffde45958723b615e64a9b1a6d0523ee"
    sha256 x86_64_linux:   "543af6a676b2d65794acc8eb8a8a29ac5faac19425a0b2fe4e273d392e6b94cb"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.12"
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

  def python3
    which("python3.12")
  end

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

    system python3, "configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write shell_output("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
