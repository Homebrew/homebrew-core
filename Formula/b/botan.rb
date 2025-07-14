class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-3.8.1.tar.xz"
  sha256 "b039681d4b861a2f5853746d8ba806f553e23869ed72d89edbfa3c3dbfa17e68"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "a967bbee75aacedb40abbea69a039efeb6d3747f60f78d7df3c990389f4bb4ee"
    sha256 arm64_sonoma:  "363aac39d5a069ded0ffad86a0d924fdeba5da34b541c47de8a91a2b8ff37a55"
    sha256 arm64_ventura: "d8bcc4c1e2fe8db29e38d6fc6420b03b9addba885332dcf37ecbde13dd1dad00"
    sha256 sonoma:        "fb26ebacd465ecc8efe8978a8b0a7a7b2b1fa9b19f5838c71e1c0b02488610f8"
    sha256 ventura:       "54669a30e929a073ae91d196a9a0929b9a4b77a05da4e026fb97f58da9ece15b"
    sha256 arm64_linux:   "13c3d6c959ea7e723868b616eddbbafe0d9d705d015e975e7e53f2dca18bc50b"
    sha256 x86_64_linux:  "3fb558f2f23a738424a0b1593e1541bf02ff454be11a1ceafadc05f30215a772"
  end

  depends_on "pkgconf" => :build
  depends_on "ca-certificates"
  depends_on "python@3.13"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1400
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  def python3
    which("python3.13")
  end

  def install
    ENV.runtime_cpu_detection

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --with-zlib
      --with-bzip2
      --with-sqlite3
      --system-cert-bundle=#{Formula["ca-certificates"].pkgetc}/cert.pem
    ]
    args << "--with-commoncrypto" if OS.mac?

    if OS.mac? && DevelopmentTools.clang_build_version <= 1400
      ENV.llvm_clang

      ldflags = %W[-L#{Formula["llvm"].opt_lib}/c++ -L#{Formula["llvm"].opt_lib}/unwind -lunwind]
      args << "--ldflags=#{ldflags.join(" ")}"
    end

    system python3, "configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write shell_output("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
