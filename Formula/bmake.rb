class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20230127.tar.gz"
  sha256 "6056866f69496699c815b2af7144701fce7f1ccb6a4743dac5d221ff157d8915"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99482a673c31a4467a54c1bb1e87a81ae5ec6d7d92e024e4f38ebcc80ea3cd0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed2892600e709af86cb8db71d711609c3c5fe344d5302da6fd0bbb428ce2c789"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c186db78215d531f8592d02e7abb5ab265d1af50679aedd538ccdb4aeec26e7"
    sha256                               ventura:        "5ec025df0a65508e721372d1db7f45a86e4d0fec63f85b6115ed4ffa9ca3cd93"
    sha256                               monterey:       "32d3c9fbd8b7818a029427ed0946c42a7e9ec5cf877e375ed43abe432220f74c"
    sha256                               big_sur:        "d3a6b5ce5028ee9f29ea25e3fbac9cb79cbea2f188ca044ac613af9cdf8f0d91"
    sha256                               x86_64_linux:   "bbfcff5fff2d43f6067c0aacdcaa70a8a8ec3d92142e58fa823096063154d401"
  end

  def install
    # Don't pre-roff cat pages.
    inreplace "mk/man.mk", "MANTARGET?", "MANTARGET"

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
