class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://orbiton.zip/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.65.11.tar.gz"
  sha256 "ed0b663a91c084a05e138a1d011931a896e6a312700b984d76385e675646ddbd"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f893387a1c8c9a29c48fec9c26676e6ad18fa76f1e1bcd54913cdd1a0709e011"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d99a635dc52c81db6ecaf8d01a89fe72c3f5c9f2beccb326767aa4a9f2f19ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d91043e5fbf42c42aa6f2ff221344e68b2de54a87fe142ea9ea1e86245483f26"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b76ecc0033828f70dce75f73df46a84beb7842fdc7389cef082d42650ec35b3"
    sha256 cellar: :any_skip_relocation, ventura:        "839d79aa4891ef66b84d40b272e1dd327654c532f2c02372dbfbc766dc52041f"
    sha256 cellar: :any_skip_relocation, monterey:       "6423e71542fffd45998f6c754321c8ca65cb387e7b39177c0b67aa07734ef628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a85f84d5c07ba9688c73f955d18b0bfe6ae963a2e76b2cec3ccf6b18b31e036"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "xorg-server" => :test
    depends_on "xclip"
  end

  def install
    system "make", "install", "symlinks", "license", "DESTDIR=", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    (testpath/"hello.txt").write "hello\n"
    copy_command = "#{bin}/o --copy #{testpath}/hello.txt"
    paste_command = "#{bin}/o --paste #{testpath}/hello2.txt"

    if OS.linux?
      system "xvfb-run", "sh", "-c", "#{copy_command} && #{paste_command}"
    else
      system copy_command
      system paste_command
    end

    assert_equal (testpath/"hello.txt").read, (testpath/"hello2.txt").read
  end
end
