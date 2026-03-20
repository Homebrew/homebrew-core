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
    sha256 cellar: :any,                 arm64_tahoe:   "7e9a39d0c7a76d4dfc59bf8c4a57ef23f7fc5dec279cfbda606ab6d29c4ee524"
    sha256 cellar: :any,                 arm64_sequoia: "a359a880525cbbdecf7b43d17beb3063e4d143708739cc656fc55d51799fbb43"
    sha256 cellar: :any,                 arm64_sonoma:  "bc9d8f45b2c08cd119591fe7c2238d4f943eaa70f6abc269d6c58d26439a4e98"
    sha256 cellar: :any,                 sonoma:        "9a63b775274a845dc0ef78d08c50dc1f8888892067da217c7b8ece851b3fb408"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53d5184e928ac968868bb2cb8cf1c490cacc9e1761f68810285d9b05d3f8cfef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57747a3638e54f01df731df623f5f63495fbdfe219067a37cda1807e0ff665f6"
  end

  depends_on "lzlib"

  on_sequoia :or_newer do
    depends_on "gcc"

    # Binaries created by Apple Clang 1700+ are broken
    fails_with :clang do
      cause "'make check' fails with '(stdin): Not enough memory'"
    end
  end

  fails_with :llvm_clang do
    cause "'make check' fails with '(stdin): Not enough memory'"
  end

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
