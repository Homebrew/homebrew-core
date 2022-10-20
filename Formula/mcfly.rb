class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://github.com/cantino/mcfly/archive/v0.6.1.tar.gz"
  sha256 "e2eebca8f66ec99ff8582886a10e8dfa1a250329ac02c27855698c8d4a33a3f2"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de234aaac82f30aa6579b36d8025d395f276eba7eb969fce673a5d2a5c6a0a12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a532b066327a10c8fd1dd48b1fd638459cb6051f3db984a4e34916aaf91518fb"
    sha256 cellar: :any_skip_relocation, monterey:       "e8f6a543c335f857fbaa14681b8da7ddc4278867a2bd1f8f23fa5e85d8de3fda"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb24ab07c5806437ce2b1b38f5935fb73b8e724c6d9c057c3ed7b9b55579cd6e"
    sha256 cellar: :any_skip_relocation, catalina:       "5a5e86761c28d8aaa22c040332e80b3ee706700f0a7d2e826fa94701bea7b8c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d3363fdffd9d4309837461927d254404c0e0b581209c2b363a10976a3b0747d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "mcfly_prompt_command", shell_output("#{bin}/mcfly init bash")
    assert_match version.to_s, shell_output("#{bin}/mcfly --version")
  end
end
