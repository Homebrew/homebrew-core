class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://orbiton.zip/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.65.8.tar.gz"
  sha256 "e6d29dc74fd55d96ecec103d764e732314ec193b5868ce944209b3bd619f65f4"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a8b00a415d6c66c6195dbb94d02c8eed121ad0794fb431a4fd273833355d922"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b68c7c8ead2c78a3975a2a4a8b3d3871123bfc11fc2fa483cf0bcbefcda5eb7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01a051722bc10a11b1057bd07e87e4604adbd1bcdeec5e7d2845d0a7263794f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d5e82e511a9a736275ea2ca9e721b5150fd852ad454f781e25264757270ae1b"
    sha256 cellar: :any_skip_relocation, ventura:        "70a2987e9b0b05351b86fb813e7785f667ede158002935e9aa7fb4a0e34124c7"
    sha256 cellar: :any_skip_relocation, monterey:       "303fb1834f83c1ef0f3279b1a4be71e78f428d825dcf01eb4db50aa5cf5d0cb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af152e357f7479e6f2bf6d8ace1162760d6cad09226e97020c2e61e72bb0c156"
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
