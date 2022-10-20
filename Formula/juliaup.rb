class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.7.24.tar.gz"
  sha256 "1f9525c0cc229cd582c60a4cb6c68d07a95704548e02d668a714149b5cfaf6fe"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06198c848a74caa308fe41f1e0418cb48a32a7ff39d7ea2f7556cfaf52f4fd7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fbf95fa78b98d7df7751bdd72ff6df681892b351f7fa529167a42a8ce5a3e1c"
    sha256 cellar: :any_skip_relocation, monterey:       "b6e50d1cf0b96f9d4b67f008b9a29bfc1ad144e1ac3e5a81d2fc1ef3ea2187d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "d70d07a164e243ad2285a1dfed26edb055d4b5d421881593022d6194a99fa068"
    sha256 cellar: :any_skip_relocation, catalina:       "925f6332510eab4099ed9480971ccfb48241b9ff6cc2858cdd21aab3d618ccfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dee022b8e9ba9bbd0752c2c1b6aab36c3243265dfbbf2bbd6e75c0e0b723872f"
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
