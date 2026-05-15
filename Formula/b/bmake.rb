class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20260508.tar.gz"
  sha256 "7b1eea90abc767430cd1a612529d5f301c47fd6a35bee7585778c951e891a82c"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6942d2b932cda9d7ed432458ba3179e19a9dec7d784a052ac574841b1507a82b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc798abe68f766e57c68d334a66c53209f1d2b139eb9e7d8f4d81f8e2884c5fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2783edd4520500c1563a2383d3806fafc42e8fc538f4cefa8fd88b6adcf2925d"
    sha256                               sonoma:        "694c59a9b791252d2ccfc9cc9973e0b1b85bbf2b0aae8ecb5e6b6613c453a870"
    sha256                               arm64_linux:   "e00b0eb28af2f4f81846531d2894a60331ffe1e40b6a54ee2e447500988dccb4"
    sha256                               x86_64_linux:  "c9b837525cc6dc909d30ff4e4f59fa8bd30cc18b3ad9eb3c1ea182d39b84ebaa"
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
