class Luit < Formula
  desc "Filter run between arbitrary application and UTF-8 terminal emulator"
  homepage "https://invisible-island.net/luit/"
  url "https://invisible-mirror.net/archives/luit/luit-20220111.tgz"
  sha256 "86c07a4ff2d4374a655a1eef2ec7504582d42bba5971c79b111364e2b26ed468"
  license "MIT"

  livecheck do
    url "https://invisible-mirror.net/archives/luit/"
    regex(/href=.*?luit[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab9acf15dbc4f57744f46cfa68d3bcad5147202fb087e62278cfabf16060e212"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd9bf86b24b93a3d09f38578724106acebb16042f7f3ff43a0d791acaf8d99c2"
    sha256 cellar: :any_skip_relocation, monterey:       "6e334b4887641701e58d69504abad516290fce2ea6fcf0e18dbd5f3e0a73023e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7dc71fd9927f1a0319136578053f3894172ed1f65301663aabafaa1d359931b0"
    sha256 cellar: :any_skip_relocation, catalina:       "6076f38bc562ff5408f986b767a20301c5c61c805881f836df3608152ae2c31c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b62d1247695d9587f5ddf316b1dc4f7e6ebba14979fce13a7dc2038f45259ce"
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}", "--without-x"
    system "make", "install"
  end

  test do
    require "pty"
    (testpath/"input").write("#end {bye}\n")
    PTY.spawn(bin/"luit", "-encoding", "GBK", "echo", "foobar") do |r, _w, _pid|
      assert_match "foobar", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
