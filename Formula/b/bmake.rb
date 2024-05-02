class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20240414.tar.gz"
  sha256 "e1ba6c230cb3acf8b4c0885efaf3ffba3905942784b29d0f7fe22201542a5d56"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17e9d583b2ce51f7e4f5b8112fa0801d097ae86cd8fbca6a61b9fa7499fc9af5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb25ca769106374b4bf5f6cbb43395e434442c5a8982f51f8e98387fda061375"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce0f946db5b385cb4646deb7f400721f5b8a2481c1678da40beb2fdbd9a961ed"
    sha256                               sonoma:         "ed13ed551fe0454d3832cd3e71a8ea59eadf6d2cd11472931a06161e3d4977ae"
    sha256                               ventura:        "39c56e9855887aeb3fe8fac8ddf83d3417736de89ff4cfb7046c599f60a6178b"
    sha256                               monterey:       "b17fdfc325e0c80c8186bf1cb69e7e27308f0028264e8d37491025345b4f152d"
    sha256                               x86_64_linux:   "781f31f3a16f70e0596213bab52948f956780202757ad54bf307033d1774868b"
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
