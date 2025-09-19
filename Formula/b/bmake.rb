class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20250804.tar.gz"
  sha256 "0b49037644b253206d2e710d46e32859e62dfe2c6c8e7218ae439f2ef50de8ad"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5390f535bc874e5d3eeed207d7384259c2943f3221daa7058729a4d85886b563"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a57472c5362530151be18f3877817b2960c4d94f1d96e8649db63b5c975dd23f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31b71a1ebb0c3d1292622c0fc17706c60cda6f65ed7ebf1db61f05b61e8550d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "830bc4e799da17de7f75aa1cd34465aa4701bc471202c2fb45db43ce92eb1070"
    sha256                               sonoma:        "1a84f32740d0e7a0dc5f283194313130881c490c2c24e05bb87ef88b3ab579e1"
    sha256                               ventura:       "78bdf13ce45210ff6f65198369e936407f681ec45edf080d2a8a85bad2f68ea5"
    sha256                               arm64_linux:   "24be7b2de47dcbd82915921fc8599d302f120f4c5dc99202e849b8c6a52ba141"
    sha256                               x86_64_linux:  "3d578e60d3b633433f4536c95fed71d00a82aac0efef13c3b5a17d3208a24aa5"
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
