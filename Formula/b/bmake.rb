class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20240212.tar.gz"
  sha256 "971d5a364035349e984d82c2a48d546a0c73e52f3b8f2aa29a3be3d2408ffaa8"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6227529182c170137701d32b26fdf38b6ed601328ee4949781887e9950310ff5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6de8f2a3ab90818b76d0e9c12873485bbf8d407b471d61c38c85bbab9d6ac28c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92df6f3e5438b89f87b6121589980c418693af775d02c0c85d86d44160d18037"
    sha256                               sonoma:         "ef3e8f7203c06a51f0073f5e7c6da850b784e49bb145b1418c30c00e4363baba"
    sha256                               ventura:        "f823e42233a6e01af779c6c582ea5827921c622f59b77586e94da972eeee4e6a"
    sha256                               monterey:       "e701cfe3e336f0808252a891f83d48d80c52f6111cf63ffb767cb27c4372febd"
    sha256                               x86_64_linux:   "a4db2671db32fb207672959e84e8931af004d37168fd2c0ecb529b8804c980aa"
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
