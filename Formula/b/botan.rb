class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-3.3.0.tar.xz"
  sha256 "368f11f426f1205aedb9e9e32368a16535dc11bd60351066e6f6664ec36b85b9"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "d98d85c922d614013c598f5cc7a9b9888571c0bd52794f0dc236cdb4227fe960"
    sha256 arm64_ventura:  "73483747bc0ea81a3cc395ae06362e5a1b62599ae8a31359345fac49490efa95"
    sha256 arm64_monterey: "0190cd16571745f62f3fde4cbb9e2684fbb5515a58e017a75ed6944f7bb00459"
    sha256 sonoma:         "278e3633f88d4644033690cd015b2609d6ca1f71fb5c2c1b5d52edde0122b87c"
    sha256 ventura:        "fa356e1c18b76c821a6f6e01f54b505a6e114b46456fa866e66ac2fdbb04732b"
    sha256 monterey:       "e6ffd406771cb6c04e5e10e6e98ececc9e70df9f34ae6b9fd0b4c70f2aad20cc"
    sha256 x86_64_linux:   "77b7e30a4687db610c06fa2f8b9eb87b0a10bfded8777d6caf4a6d2150c69ac1"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.12"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with gcc: "5"

  def python3
    which("python3.12")
  end

  def install
    ENV.cxx11
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1400

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
