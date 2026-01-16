class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://roboticoverlords.org/orbiton/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.70.5.tar.gz"
  sha256 "ec8e9de9f392c424bdba8fdce926e85340edc73734aec4c2c8d987d804f56fb6"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcc5d60979bb0d7ed97b6d00e190bb2a41547ab62b73d2abb3362ee27246e1f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcc5d60979bb0d7ed97b6d00e190bb2a41547ab62b73d2abb3362ee27246e1f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcc5d60979bb0d7ed97b6d00e190bb2a41547ab62b73d2abb3362ee27246e1f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5ddf38a32c7116f56ac54847759ac497deeaa12409469e94544c644fd56b59c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5b665239fd45b1fef6b5a78e8556497991f2cb5db9cd7d9613993a6cbe177cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "225260fd2433e3fb7ce2739b4487a19fde1adf8eec1ea612a7e0ac8564086747"
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
