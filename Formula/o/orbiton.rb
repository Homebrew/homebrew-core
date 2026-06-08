class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://roboticoverlords.org/orbiton/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.74.3.tar.gz"
  sha256 "d1e4353ba7d5c75627216a5a27892ff1ad38fcb6651f59ce9d86dac5b8a1700b"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb9323f4091412048f89023675837b0f415762827d6df46e85bfcac6e10474ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb9323f4091412048f89023675837b0f415762827d6df46e85bfcac6e10474ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb9323f4091412048f89023675837b0f415762827d6df46e85bfcac6e10474ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "d09c77d3f4a9df12919199351f85bc902967352a27c8c00c6289315f80569c33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcd700eba4fa52cb5b26afb601de91b937b5e2c19114de995715c556ec6afe41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07b170036ca9f5823bd0bf81392ed3f1b3abd3d92be1a11c1d4ee8a2fa6a902b"
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
