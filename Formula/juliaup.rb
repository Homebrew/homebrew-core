class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.6.1.tar.gz"
  sha256 "66280691ae029015fb459679703e59830260937dde97a1217a513d262326c0b9"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b90318043ca790c0d98ae951f86b1a9b8f5981c1ef441399f6dcb8ce1aac8e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc4ece97e93bfe071eeca1a2c48a23806e01b2b343fb2e62cc1792a14ea24fad"
    sha256 cellar: :any_skip_relocation, monterey:       "f2fda8cccaf2bcb9b1a91e470b032da029d5ab77a4a219f5b9b99453fa9bec75"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f9ca877c5bff91acf71499e68bbdced24586a7542c915382ff15331d9480cd7"
    sha256 cellar: :any_skip_relocation, catalina:       "b11ce6f680bea82c87d7249d503dc8eed037e57c0855d9f7541edf84954885eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a77ef9a4ba37e15322cdf0e238e55d0ec8b9a5a3ac79f23f0c6a80151479cc2"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
