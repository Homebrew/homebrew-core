class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20240602.tar.gz"
  sha256 "44a0f7b0cecd71dc43a03c8fd5eda6d159e0d7e1302f669cc03203e75dde7b9b"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bfc79323a1cdaa02916bbdcfc0da897ef62e7973c2e7afa3bd61d8360f0e518"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ded987184910e3fc7cdfd80a20b593bda0c9ff04c596d01cba095375f181d73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "373a24aec251e2e6b16ace056f1b0ddd7e54bb30fbdf4b43d708ae3239a0acc4"
    sha256                               sonoma:         "e3373c2a7e1a90065283d317936bcc464ca20a3dec74f3befb237d450c2eabc1"
    sha256                               ventura:        "9a4cde1b7dc510ef8f98be920e6428c43c656b590c0f72b62f8f7fbe5f93492a"
    sha256                               monterey:       "efbfae694092440d3f5b7b877d286f02cab0da540d7ac046102bf83f3e3bbd9b"
    sha256                               x86_64_linux:   "54313fb241d5a4dd682039dd2c22253a6dd1bb6cf0a0a9fae197030620ef419b"
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
