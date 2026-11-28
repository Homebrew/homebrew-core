class Plzip < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/plzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.13.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/plzip/plzip-1.13.tar.gz"
  sha256 "64d49dde20daa5fdff2b3ff28e3348082de10dd54eb10df6da7d1bc6c7a6db64"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/plzip/"
    regex(/href=.*?plzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    manifest_sha256 "6893056cf3586a2e71cf7408ddd8ad21b928a16cb5ec8324b0e6c7ba77c3164a"
    sha256 cellar: :any, arm64_golden_gate: "331cd6e7e526dc06708c19559d1cfa3882adeddf0bf1cead770e3c6761a25b71"
    sha256 cellar: :any, arm64_tahoe:       "250d32de5b3fce4d58159136e7cc68aa9c604bfba12f8a0698c516773817ab6b"
    sha256 cellar: :any, arm64_sequoia:     "2b207945b1a8f79617b37d2cda4872e16be8271e18bff16342692daa5fe6b5f0"
    sha256 cellar: :any, arm64_linux:       "af2b780826ee1dbbd6d666f46818888ff7fa1c59d9f5dd1fb572360f4d8479b1"
    sha256 cellar: :any, x86_64_linux:      "39180c8fc13acf749a8a42b3fa2884e6a9ac5a896a462038d5da9917fa7c9a9d"
  end

  depends_on "lzlib"

  # Apply FreeBSD patch to work around LLVM bug which impacts Apple Clang 1700+
  # Can switch to fails_with DSL once LLVM fixes issue in stable release.
  # Ref: https://github.com/llvm/llvm-project/issues/246281
  # Ref: https://lists.gnu.org/archive/html/lzip-bug/2026-11/msg00011.html
  patch do
    on_sequoia :or_newer do
      url "https://raw.githubusercontent.com/freebsd/freebsd-ports/37f646ddcfe62f48e5641429e8398369a592b211/archivers/plzip/files/patch-dec__stream.cc"
      sha256 "d2738a5a9f221ac35e4eb1ad649b57576711cf1adb4f3c2d8b0d5b9cc054e508"
      type :unofficial
    end
  end

  deny_network_access!

  def install
    # Not an autotools configure script
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    text = "Hello Homebrew!"
    compressed = pipe_output("#{bin}/plzip -c", text)
    assert_equal text, pipe_output("#{bin}/plzip -d", compressed)
  end
end
