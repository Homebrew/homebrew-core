class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://roboticoverlords.org/orbiton/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.72.1.tar.gz"
  sha256 "475436a990156424e5ef29730e6d3aaf04e8cc245a009a4c60c6658e1f636b7d"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a49c40725ec990d9b6706c5bbc7d7e2384cb310777248d8f9cfee033519e8e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a49c40725ec990d9b6706c5bbc7d7e2384cb310777248d8f9cfee033519e8e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a49c40725ec990d9b6706c5bbc7d7e2384cb310777248d8f9cfee033519e8e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "45049e84ea8aa0c191e8c99fdd6dddf08fc2a6abe1a0bc902161886b4e4a54f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdc5d4171fde839ba21709fda52288e42a2059bdb817be72cc65eadc0e2d6504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1041847db39b12b27d2068492b1b7606bf456b8ed8217673b2929425ff459cc"
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
