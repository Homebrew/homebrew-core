class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https://www.phylum.io"
  url "https://github.com/phylum-dev/cli/archive/refs/tags/v6.3.0.tar.gz"
  sha256 "b9425ced21347e4abba3cc0855cbed1d58ed4f9530141d44b4ff6c150d0dd646"
  license "GPL-3.0-or-later"
  head "https://github.com/phylum-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "908b371fa615216fa1ce1293ebe8beac22c66db26fad77bc835a017abc4af7bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "508b5d278f5ab340a75045a7d1974c09d0c99ced60dd32fff4b5a42f25864edf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1568dc5014b88fe574e7ce2fca94fa524579709b5ff641c82e6cfb12cbeb35c"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f55a2234cc61a7088a4f74dc8f7ff17f4b1428782a68f9bdd39246dcb4414ad"
    sha256 cellar: :any_skip_relocation, ventura:        "bc770dc08797a0f348b797a4d6d3ebbbde561a7c01d8e971eaf6ce5e2c2a5453"
    sha256 cellar: :any_skip_relocation, monterey:       "90c9bc1ea7978021ef597727735f041a4342191bd64e34864fce478630fd9e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6b5850edf5b74e004645d9b1ec5c9036b399bad37f6fac709050370bf206dd0"
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
