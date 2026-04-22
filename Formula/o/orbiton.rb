class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://roboticoverlords.org/orbiton/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.73.1.tar.gz"
  sha256 "e8096a71fb17c742f6259d56b606128e7e006a36452123c87a49e92e6d7219f9"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2ba3448676dec729543c5ba4d3d4751e3e039a6623b2ad2bf1beac7e81d1a4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2ba3448676dec729543c5ba4d3d4751e3e039a6623b2ad2bf1beac7e81d1a4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2ba3448676dec729543c5ba4d3d4751e3e039a6623b2ad2bf1beac7e81d1a4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "561e96013cfa2b99f0dc4c6ed58ab2df4e16d38b683ae691fa714fae809de113"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56e04c8623170b4e18345a48a131cda0a9422e08ecf4ac4259e83f4dd7b1aac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ba8c4760de371897ea47129548092cbd337259f7cbdf3fb69d5c1f4ac8e3dcc"
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
