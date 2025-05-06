class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://roboticoverlords.org/orbiton/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.69.0.tar.gz"
  sha256 "dd8205b863a7c177cca3d26c952455f3b1c5ee6614408f2c262a22e8386228bb"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c246e25a7f0c7f226f130b76500913222ad331aec17bcf12617cab6803f4f146"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c246e25a7f0c7f226f130b76500913222ad331aec17bcf12617cab6803f4f146"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c246e25a7f0c7f226f130b76500913222ad331aec17bcf12617cab6803f4f146"
    sha256 cellar: :any_skip_relocation, sonoma:        "d55a4750c9fad01cad8f136783b0236b57a446fc03ed7764db239e8d449126be"
    sha256 cellar: :any_skip_relocation, ventura:       "d55a4750c9fad01cad8f136783b0236b57a446fc03ed7764db239e8d449126be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "909b0a9743154e539333ea0666d55d5b3976373bc2dff363f5a7482abd6f438a"
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
