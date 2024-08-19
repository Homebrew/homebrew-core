class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https://www.phylum.io"
  url "https://github.com/phylum-dev/cli/archive/refs/tags/v6.6.6.tar.gz"
  sha256 "05868260995706de7221da21c3ed399122957129a58f5427477cac97681f8725"
  license "GPL-3.0-or-later"
  head "https://github.com/phylum-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a825f487e0b57a50176289ef53e5d77c0cc828f753d8d18d7f979e7f7dde1b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5603cecce3a03193fa6e11fcb1829843ba18ccf9a9cb8b3ce71ea43261189753"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93e2e7e6687ed24ae8a1ef8e2f703a55d8aaefecd285de258b63f6a8d86a8eae"
    sha256 cellar: :any_skip_relocation, sonoma:         "f416868d054e1aab5bfc3923f214dc42e5070c5e457b6cb58f9948245335ac0a"
    sha256 cellar: :any_skip_relocation, ventura:        "af57370276f73e564e50ed6e4f4b534222571ae38a2153c40e721ccbe2d381b5"
    sha256 cellar: :any_skip_relocation, monterey:       "3a1b1b1756ed8c7fe0f93f192dc417c450fdc20744db87d98ee1621e4033e7c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce99f6d349799ca89bc13a8246384999a716b88533b6a964785cd4a26c67be8e"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cli")

    # Generate and install shell completions
    system "cargo", "run", "--package", "xtask", "--no-default-features", "gencomp"
    bash_completion.install "target/completions/phylum.bash" => "phylum"
    zsh_completion.install "target/completions/_phylum"
    fish_completion.install "target/completions/phylum.fish"
  end

  def caveats
    <<~EOS
      No official extensions have been preinstalled.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/phylum --version")

    output = shell_output("#{bin}/phylum extension")
    assert_match "No extensions are currently installed.", output
  end
end
