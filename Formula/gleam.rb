class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.29.0.tar.gz"
  sha256 "74376782e7d68535107bb616270b5aa0f5eb7fe44e59516891727f6b33c10656"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bb56b2a882c15ebc9ff7e4869672458ce2a2d0b91eb818e5258eb99c62bd0b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44d2670562eac39324914078cfbc3995bf57156d04fe586185dfc1967e17c4c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e6f8444c24fd9f0fc1f8a256e9d87e732537a75d30cbe39bb06e8e6660f975b"
    sha256 cellar: :any_skip_relocation, ventura:        "b440b871aa001f7a35dc11555ae2ea9ca45fdee217ffac1e58ce09a9fead01c5"
    sha256 cellar: :any_skip_relocation, monterey:       "eb9e6528a700a0f3c37cfb45e3cff2ecaf8cf4b8c27da8728a7f52f8fcff6ded"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1f9546dbb57f171062301e7f88cef4ab4449a0a8c8bc7890bf37a347496d7b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "220e0ea0ed08e67848a4894a890b1106dfd60c63aa49ce381fe5fdee2cdddfc7"
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    Dir.chdir testpath
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin/"gleam", "test"
  end
end
