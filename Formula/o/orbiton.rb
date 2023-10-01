class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://orbiton.zip/"
  url "https://github.com/xyproto/orbiton/archive/v2.65.0.tar.gz"
  sha256 "41ffe579fcb5791e47d44eae7252d74d5c99cba8c217b619198a6c4dc49f8292"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c6ae09b5490e33f813851676405e5b75d6a652db6d112d554ad4a82f337d9f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "166f74a1573fe95fd2da8593d42275926bbd823b58b8e58413eb645a7ca85ac5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a31baebfb33bd1a67d90366f1f717af2da8faeb7d1d25425a9318e2ca1d80c60"
    sha256 cellar: :any_skip_relocation, ventura:        "e84e6daf3f1aceb3483ccb34958b6d9535081363cf37bf47874d5a8b92c4b5fc"
    sha256 cellar: :any_skip_relocation, monterey:       "d793cddf697d36c3bb907d9a8b228128a42c09bd195f018c8d71bfbf53d56450"
    sha256 cellar: :any_skip_relocation, big_sur:        "488ddb6a832ac3fc552a931f94d12fe16d788067ee44d1ee72033c46c566ffd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35c9bf6df15061e11eaa3c8ae3ccae284c30fbef6c86e5f3dfa367eeeb514a4f"
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
