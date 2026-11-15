class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://roboticoverlords.org/orbiton/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.75.0.tar.gz"
  sha256 "12fcbe320917f41c389146ece50e9627554da4023e15cf01a1516cc90ec19b29"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "613a11a1e024856175564516349b636cd7b736825a1799a3a47615d9a802e9b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "613a11a1e024856175564516349b636cd7b736825a1799a3a47615d9a802e9b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "613a11a1e024856175564516349b636cd7b736825a1799a3a47615d9a802e9b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ad4f96db963fc062dc521b0354629481ca514d96db9ab45875d21808b54afee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7fbe712831b6b3ddcc34c12c16c3f9eaf50fc816b075d1fa25899af23671883f"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "xorg-server" => :test
    depends_on "xclip"
  end

  deny_network_access!

  def install
    system "make", "install", "symlinks", "license", "DESTDIR=", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    (testpath/"hello.txt").write "hello\n"
    copy_command = "#{bin}/o --copy #{testpath}/hello.txt"
    paste_command = "#{bin}/o --paste #{testpath}/hello2.txt"

    if OS.linux?
      system "xvfb-run", "sh", "-c", "#{copy_command} && #{paste_command}"
      assert_equal (testpath/"hello.txt").read, (testpath/"hello2.txt").read
    else
      # `--copy` and `--paste` need the pasteboard, which the test sandbox blocks
      assert_match "hello", shell_output("#{bin}/o --list #{testpath}/hello.txt")
    end
  end
end
