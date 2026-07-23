class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20260704.tar.gz"
  sha256 "1ad2620cb58addcfbd25d80d21bad9139e3a672b8f08c5f7e57f84119ecef3e3"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ffe329d084e6748a95ea2f6bae128cffc9000fac3acd799110ab3049478a6f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ea6998341f9f4fe088cd0500aedc742d568707426c6d36e5ebe072d2a8521a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5cd9b0b6fbc658e3a80f493a3cf28ddf82df58a11312027aaa9fdbfc7367131"
    sha256                               sonoma:        "3bf6ba6b3a51e866bdc0173848707125dedbae881fad5395b822050d71d4ec91"
    sha256                               arm64_linux:   "9d10ab87c4ca0f3e2e939397e81b84ddbcfa5f7da1a7e29ee1e1b54556a44c41"
    sha256                               x86_64_linux:  "e1c363aa64731e97d254c412f21bbe6b27fb91ca4e2c8d0e16f20be6cb9a3cc7"
  end

  uses_from_macos "bc-gh" => :build

  def install
    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install", "BROKEN_TESTS=shell-ksh"]
    system "sh", "boot-strap", *args
  end

  test do
    (testpath/"Makefile").write <<~MAKE
      all: hello

      hello:
      	@echo 'Test successful.'

      clean:
      	rm -rf Makefile
    MAKE
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
