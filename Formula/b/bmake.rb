class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20251111.tar.gz"
  sha256 "45a3f8515677ba8f3933d8213f4bb611a5c3c88380be2e46222fa44709506060"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d070080a4140d21e1c694e09b76fdd001e4a3eafdfe8d3baf16e1aa7507ee92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a77d928e461ccdba42f1b154fb546b7218448ad6c4e1fc600e290adfdd3e05fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad718142f1eaf42776e99ab60a0c68f948306482a8b429e6cf49c007ee077ac5"
    sha256                               sonoma:        "62df628ad69f8e99aff0ee492cd15698ca13694b122e99e852d0b6c35f32f961"
    sha256                               arm64_linux:   "685f5997646e8924f2023b6f2ecf00ed7ef5fb099a9ce78d7cf94201ed9fcad2"
    sha256                               x86_64_linux:  "05ad36b4ab08784d9a3063c8dab2d705f8d36710a4a499ff87bdd05c7c3fe151"
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
