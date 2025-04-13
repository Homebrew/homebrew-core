class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20250404.tar.gz"
  sha256 "392a67e2c4b685f0afa6da886b551ad0b77644c7b622d5b07fb2144530e90376"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fc57e54b119669920e9033522053df95041fee7b29e4dbf23f1bae947d9ca94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64af7d6337d133e9b64902fdc85e520330ab9e99a7743b773cc3926b669cc3f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "553e0de84cae192eac20edfa1a4e827363d39a7947a5a596e569e9e7cd87fdae"
    sha256                               sonoma:        "32442f8a813a5d044a555d5399b13266d71f7ca6569718bdd9c4a140cd2d361a"
    sha256                               ventura:       "c71e46ac9f88c7ce0bcc70b3f07aacc0fc989a9e7f9215928f454e2b34ae3685"
    sha256                               arm64_linux:   "de306204ce66f566e9356e7cbab4dddc552e178cb236be2c07d22bb60dd02998"
    sha256                               x86_64_linux:  "199f73137259de4d1b5b6ef3109ab578193ca4f2b78b9def9dbb236573ad56a8"
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
