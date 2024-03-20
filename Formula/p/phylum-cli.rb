class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https://www.phylum.io"
  url "https://github.com/phylum-dev/cli/archive/refs/tags/v6.2.0.tar.gz"
  sha256 "abeb3e86f2b41060057c4f10f9fb5fd281e6739946db1c11874e50c131dc0683"
  license "GPL-3.0-or-later"
  head "https://github.com/phylum-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f22db4b5d200c3834cb3b7fda6b0c245a3122139b0311a46321417f1c28183d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0375374c2e86e9126ef38b61c50fd67109c3eab852021d22703a29f64e1b399d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93be2c7257bd3e26c49b0d5e3a37447a5a186c59d45783e14b4bca8fc9a2b4be"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3982fbee3a289c059d0e15e8d799e045d3b2011ad516b06c8282111b4dea146"
    sha256 cellar: :any_skip_relocation, ventura:        "a44f593d363e93e886b6b5726b68e911dda0783fd0224764a721b5e072b49aec"
    sha256 cellar: :any_skip_relocation, monterey:       "c9e8e4cf84ed2074bdf231ff693a3db6d74e367bec388dd06745d5434a8314cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e1faa8bfaeb78296c552ab296fce876474dc987de28080f99b942b9a2b35cdc"
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
