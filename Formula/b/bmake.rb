class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20250618.tar.gz"
  sha256 "9651ce09d31b64a90625ab52af54fd90bf78cfe706c86991d0b44cb3033c0eb7"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5990b32cd2844212de6c7dd92b5d59adbbbbb19c96d4f4979ca75026309cae22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50627bd7f9da343220854e9e108da6f15123cf42225fd6a79b75089502389c77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b601d119275912f4bb2de5b96591d6fb2eff57565d4c9b071b7d02ea42cb896b"
    sha256                               sonoma:        "75361c2334d09948a2711203b8dfed9bdd9c23038123d7cb46ee76709f033da6"
    sha256                               ventura:       "392f6dbebd8a79bdde4e14c4513b66ee096394dea08f91754d8fe45aa10f4b75"
    sha256                               arm64_linux:   "92fd21b5b6cccb3af28c5b7408d9a077e84910ea5c22bb932286c63c5ea8165b"
    sha256                               x86_64_linux:  "c5b222158359e846077808ba7352ad70d90f7edf68a2dd1cd637ef3609a56a6c"
  end

  uses_from_macos "bc" => :build

  def install
    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install", "BROKEN_TESTS=shell-ksh"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
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
