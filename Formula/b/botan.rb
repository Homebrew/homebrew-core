class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-3.1.1.tar.xz"
  sha256 "30c84fe919936a98fef5331f246c62aa2c0e4d2085b2d4511207f6a20afa3a6b"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "e155fbf0abfa49d3f24acddb83cde96ee8944f8e5f4870619b9f367db91aa093"
    sha256 arm64_monterey: "4ad92355e643a718b79f59ea39fcaee2e178f6aacc6a5d45b91c2c99b3f1ad1d"
    sha256 arm64_big_sur:  "086afb441414ac0c21a9a2cd4bfc63925cb84025149a3f067514a09712ed554b"
    sha256 ventura:        "04b5659a9a85f81083e21c477b2e45f49e49e932130bbdacab0d6ebd8d1104f2"
    sha256 monterey:       "a7b3dee57d226c222d62983346d9bce72e5c66adbda19f8c11bb92fe45548758"
    sha256 big_sur:        "83028e70de04793e28f3b50839522ec69c1e1301ec5712e7a52564e3f50cf97c"
    sha256 x86_64_linux:   "ac1c5782f0db87f770212ef4ec2ee0593746025fd231ddabce960827c15c62f6"
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
