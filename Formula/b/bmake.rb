class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20240404.tar.gz"
  sha256 "60dfb60090086f2d008d9c4ec8a224c992a3e62522cc06e43764d5d1e3d7d8bd"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "499ad0ebd4cf5ad280ecc0011bc3d0dd4aeab7dc499acfa4a75cb4551f6f519c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9f412478b0ef411a89b50885a6fa7ea9c77fe41c61bdc2690ae76823b58d343"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0b4d0e1440b5466e542b60c0e8a05c4f9bdb14211619e6d6b5df728a5d411c4"
    sha256                               sonoma:         "064d2121a91a5f2dd230fd8309206e8cc8bc994f5e80d522d5c77918de1f3b3e"
    sha256                               ventura:        "b0396d34dc1cdd6a49f1ed7adf0117ad51c8725ad084e85cff056811bb66a1e2"
    sha256                               monterey:       "a631f0bf4b72c2c0399e446a2cdc3cdaa4655736ca9b0077b3e549d66bc00bb9"
    sha256                               x86_64_linux:   "da2a8be95d8e0a98ce891f8123c3fbff174fb38c8d479419a2884e12a533f989"
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
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
