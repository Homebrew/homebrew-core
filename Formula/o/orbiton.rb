class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://roboticoverlords.org/orbiton/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.74.4.tar.gz"
  sha256 "5b4004fe86f2335e4b16c11a118d72fee29ecf115f24d76022454a2f8a8a1fa8"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caa005e26ba6a2371c0af104ce83b2ac4c689b24e1bde5119eb1ac5045257ebc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caa005e26ba6a2371c0af104ce83b2ac4c689b24e1bde5119eb1ac5045257ebc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caa005e26ba6a2371c0af104ce83b2ac4c689b24e1bde5119eb1ac5045257ebc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2924657469223ea95285220e3f4e970daa3ae34e0b53b04e032282adc04f51e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a069f1a3ab4e9aed7dafaac70151a6a3dda036166cf3fa497c4075a08c5c8948"
    sha256 cellar: :any,                 x86_64_linux:  "038bc714f8fd6155c352b9c835c708669a46ff847b4d6110d5bb602f5311c463"
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
