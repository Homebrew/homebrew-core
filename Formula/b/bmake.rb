class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20260714.tar.gz"
  sha256 "0810781d24ad6efe010a8ce91c5c529dc8dd95a561d6c93b30e56b8d679cce65"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14b7b36b35ef6206636e11b5122bd1ff23792617f3559a724715c097cd68d82f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f313a87f0922d80c0db189fa7c9a3a562cd8e0b63d4ce1f18113d8387d7045d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac325000348a6162132c8c8a43cef7a1e82b4fdcfd98de7e7d19c7608c8e4070"
    sha256                               sonoma:        "cf12142896435675d1618658bd4f4d2858d5992fb287006a56d2546a2f57d842"
    sha256                               arm64_linux:   "aba2081c9bccc5ec2ecc93debba075e224df6f24deaa7325c2b15dd02fbae8e5"
    sha256                               x86_64_linux:  "193fef291d0419dbf768bd0b2e97adb4bec9657e0324c85a9227d99bfb570b83"
  end

  uses_from_macos "bc-gh" => :build

  def install
    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    broken_tests = %w[shell-ksh]
    if OS.linux?
      # The sandbox denies reading "/", which these unit tests and "bmake -r -m /" need
      ENV["MK_AUTO_OBJ"] = "no"
      broken_tests += %w[dir opt-chdir opt-where-am-i varname-dot-curdir varname-dot-path]
    end
    ENV["BROKEN_TESTS"] = broken_tests.join(" ")

    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install"]
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
