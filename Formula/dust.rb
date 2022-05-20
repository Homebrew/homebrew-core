class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.8.0.tar.gz"
  sha256 "dc033a6fb4f31520ab1bb403dd910aed04037964ab1406363cce2185a8bd3d3b"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b05f263268332944a219d854546f999de90ac029d10e2947c98702239e6eb7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f303d90b315765441bc593d0855559ceb289a9e8637833173b283df76f3a3d79"
    sha256 cellar: :any_skip_relocation, monterey:       "b5b9e12bd8ebee98e9d1cb193832e4ab138e6bf74e71e6188986f1082dfc9d9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fdd946e035486cfd039e7f9aa515060a0ce37ae77d8500b177b46c74e2397e2"
    sha256 cellar: :any_skip_relocation, catalina:       "c39afa0bf516035198979a2bbe71090f0d893fa0329a3e4fe5f926589fcfc919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7e2fd3c7e1d34fb2cbdb10a383c28cd3de967c5152f20df26d7d2fffea3308c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match(/\d+.+?\./, shell_output("#{bin}/dust -n 1"))
  end
end
