class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "30a30e66c3e22e4f7680b2cb03c52452d457b38689ae219e9329e936e76bfb08"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b9efcb31d544a161916bee6fca2d8c21257c6c81db7ccc1ce3bcb261c482bc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f78236179761a2353476abf336e99859df3cf35e11a5706d74b298ce9b125a59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e61a04cc3408132adfb604abca80898eaff7ad2ddc6e8c5801032fc397f23925"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a20d52d4ce7fa23455a3b2fbc5acda309b516f80326b57881375a7b8d4d432d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18c928ffa2119eeeddec1530d68347607ca61c4d0ad1bc469e7697df9b3599ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cabf70da47b62e902061c8a20926046f5c0344a7c6f7fa8aa288940f4a5d20b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
