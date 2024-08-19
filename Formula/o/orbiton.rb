class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://roboticoverlords.org/orbiton/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.65.12.tar.gz"
  sha256 "6755f93c7378374f871f64f24b94d209fff896ce46a4942cc060dd7ed420df52"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "880a5dc8f88037f56a69d7f249fc8412999e33e800c53937ee85d8017d9842c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c811885231dfe1dcbdc201c1d7d52dcf33db66eb3abbb52c101fd8866276f312"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96a6b82848891e312fb53a33848b7b2228bf691cd512b361c135bcda957dc1ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e7a33eed9ab68e99c782a06f7a7f9a0d735e5d52c05df864c24e045ea47d049"
    sha256 cellar: :any_skip_relocation, ventura:        "316f6dfac6b14ff91334d7192af759c5bdb97b55954bdc8d4c8457bb0ab30b3d"
    sha256 cellar: :any_skip_relocation, monterey:       "1486d5ab8cbbf94a6250fce6757abe77624ad75222ad622352b13bce7f9e01de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50a5ccbf7a57239471337fc55ae3635fb8924de19d964f68610b7cba22d1e793"
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
