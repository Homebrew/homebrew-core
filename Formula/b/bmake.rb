class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20260313.tar.gz"
  sha256 "76c8f3cd42ee05cffb47bcc81256e3d5e7426f4d08e733788b45985dedf4f975"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bedd0ecd091fd7932b03c5e32b95ca5c59644c28c5dd6c8029c0c071202560dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f55db8eb1e269cdd70b5aeaf2ea49ba40a5d7234075ece16a710b67fbdc1b6a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a13a8439a2e0e92e2002118ec82904f02c62997f7c877ee51a2bb66d51131b47"
    sha256                               sonoma:        "9d11f18fd08dca94725ad8446ed0034ff95ad0913de616764dc5047dc50a81d4"
    sha256                               arm64_linux:   "945abf411413c42ee8b617273101cd0db34ec7d9255b6acdcc0366f799e12b15"
    sha256                               x86_64_linux:  "2a7874053df766e69b8b211ab6df5f858e95f3af720dec4df028dd376972c338"
  end

  uses_from_macos "bc-gh" => :build

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
