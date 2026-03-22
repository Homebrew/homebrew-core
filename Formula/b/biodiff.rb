class Biodiff < Formula
  desc "Hex diff viewer using alignment algorithms from biology"
  homepage "https://github.com/8051Enthusiast/biodiff"
  url "https://github.com/8051Enthusiast/biodiff.git",
      tag:      "v1.2.1",
      revision: "48468e9e7493c5bec608035f86459feb2469be14"
  license "MIT"
  head "https://github.com/8051Enthusiast/biodiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c939875ccb2ba0bdca25c0893e40a984bb8a0911f6b1e11a3fafcad5e3b3962e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "08203fed461dddc5d59a07694f40c3f6a42b8cf9c1aeec91e3fc943936bd2315"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "472ba7b9f5d1166d147ccb15471af31ce1bbab00f6f0c7313fe21d8cb70d6e9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "929f49840064e70ab6ac4c60a3059eaf9c65484d04cc4971826ffeb9229b67ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04c01a76177d041505fd9c1fdb40415428a08ceb556f687f79386ea560abc233"
    sha256 cellar: :any_skip_relocation, sonoma:         "5072d40346a831e078adcd0cf7b0706f24963216a4e29487d734409b214ddecc"
    sha256 cellar: :any_skip_relocation, ventura:        "036e815818cfc7a42cf07835cc78dcd3915e84f0056dc4f7dd35ad4625d2d687"
    sha256 cellar: :any_skip_relocation, monterey:       "69f3a2a771625fdeca1da0718990b71876fe62acfe527ceee508db0e8dc82484"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8217e0944fd572a40bfb517c730e6927c8aea6750f7afe8d71d18eba1bc0ee71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "457e5aac74347eb07659a465a925c7720dbfbaf017b7563151bfe5acac10ad99"
  end

  depends_on "cmake" => :build # for biodiff-wfa2-sys
  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    begin
      (testpath/"file1").write "foo"
      (testpath/"file2").write "bar"

      r, w, pid = PTY.spawn "#{bin}/biodiff file1 file2"
      sleep 1
      w.write "q"
      assert_match "unaligned            file1  | unaligned            file2", r.read

      assert_match version.to_s, shell_output("#{bin}/biodiff --version")
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
