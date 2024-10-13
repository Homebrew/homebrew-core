class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20240921.tar.gz"
  sha256 "b346579e82d296d1a4da29dea8594e3ee596130b20786dec0f3899a3e11275c2"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c85dbe90351c8e8058ec94af33e389f5c71145dae4735f4e307c719292bb3a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8786570e597d05a1919c6f8e85a8697783a3eb5019878bee02378e707685c371"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "889ca47c405695cff31837b61892228d5e8278811cdaf427453eb25e95543024"
    sha256                               sonoma:        "15a393bf9eab11a17f79a2b3011e9ad2ad700cc54fcbd8b7fcb76d56079dfd92"
    sha256                               ventura:       "a5f8e58133ff960824383ac74cd38e05cd25daaeff84924a8a27c91ae4e5d8b2"
    sha256                               x86_64_linux:  "4f896ff027fcf4ca3453c53bfe4673fce8904aa6a02eda0f09feede7faf0a57f"
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
