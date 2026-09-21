class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20260912.tar.gz"
  sha256 "b6bd32964cbe451be2838822c9d200b7c7e76a2a5947c03feb71dc6bd72988bd"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "47a0576cf8407e0ddf40c9f4b2451390098d5b1c95fc6c7530990d487b5382cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "93f2a6f6db6d6fa92fa29472294bcf2d8bb358eae85bce25a3c7d80fc3c14956"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aeb5e436cc198a498e1f90442eefa854ac2c46db20fced7bb0e1c9198b2f838d"
    sha256                               arm64_linux:       "0ff638f07d03a31fe4ad471a955407c33cc4de360d9693e089208d7afd780a71"
    sha256                               x86_64_linux:      "091dbce9cdb453409cb546dd26ef91771e4b68dea28e5fed5246904b31be3d09"
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
