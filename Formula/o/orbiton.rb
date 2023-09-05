class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://orbiton.zip/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.64.3.tar.gz"
  sha256 "f3ebdcdc7cb3502705ceda208510da1a43e65b5e0cb33e57b86564667b48303f"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cce42d3d44f9169e96b22a661a83e31320b9a74f40ef86b09d24bbb08c76834e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42adc1d5494be542f1cbaab358de81d99ee3ffe89f326b0725643858bf588f41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3dafb870e7bed6b18f838093defa795d8ba81e4385dc7961ccdd7941efc561e"
    sha256 cellar: :any_skip_relocation, ventura:        "e6f3ca44032831f56be2d881c96f4f984cfbdfe2958ded997988d94073898e04"
    sha256 cellar: :any_skip_relocation, monterey:       "b6284a4e4d41b4c29a3a4ad087b4f09fd0e00f1bdf4f28c4523f5194873ac36c"
    sha256 cellar: :any_skip_relocation, big_sur:        "98c9825dcdf426d20b634f84bab15d2466575331af1e0939e05673f61c32e485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12bc5130e3ac33611627e3fd5ed95631b56e04cfbeb14c7cce317c9d486b29e5"
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
