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
    manifest_sha256 "f4979c8ee3f6eb650186c1ab9f78401842b9aec1d6bd5a2c50a6e0bdebea61c0"
    sha256 cellar: :any,                 arm64_golden_gate: "90e4a359b4df994668fd79f2fc8a136470d3915643c65b63ee3bacb79b4fd746"
    sha256 cellar: :any,                 arm64_tahoe:       "7e9a39d0c7a76d4dfc59bf8c4a57ef23f7fc5dec279cfbda606ab6d29c4ee524"
    sha256 cellar: :any,                 arm64_sequoia:     "a359a880525cbbdecf7b43d17beb3063e4d143708739cc656fc55d51799fbb43"
    sha256 cellar: :any,                 arm64_sonoma:      "bc9d8f45b2c08cd119591fe7c2238d4f943eaa70f6abc269d6c58d26439a4e98"
    sha256 cellar: :any,                 sonoma:            "9a63b775274a845dc0ef78d08c50dc1f8888892067da217c7b8ece851b3fb408"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "53d5184e928ac968868bb2cb8cf1c490cacc9e1761f68810285d9b05d3f8cfef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "57747a3638e54f01df731df623f5f63495fbdfe219067a37cda1807e0ff665f6"
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
