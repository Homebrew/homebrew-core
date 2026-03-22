class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https://www.phylum.io"
  url "https://github.com/phylum-dev/cli/archive/refs/tags/v7.5.0.tar.gz"
  sha256 "a3fe16d9e76872a1dc00c5ba7897806f0e8581a4f4ebb9cc8c4410ae2438d1a7"
  license "GPL-3.0-or-later"
  head "https://github.com/phylum-dev/cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5c41404363af5e2bb318cad8f06e8cd609343c3b4efaeca80516e070c5b26b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "953504f633a2d23202b0e33a9ba472be2b6a181c9c2987998b4e3eb3de1028e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff9f5c763d8accf8b1b12d99de451c6ac96d5bbdef58853f91fc4668c476e741"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bd8a1e2cb8065e893c93345403ef305ee324629f02269268325899f15101d46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5b7d147df44d98eae7c21b1eb90a6529a81209a11b197068c8da2172da8bd8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feac0ee8c27d884b9a2f4a04a1c240878b498abb40b0d050329b42b69a6d5bb0"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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

    assert_match <<~EOS, shell_output("#{bin}/phylum status")
      Project: null
      Group: null
      Project Root: null
      Dependency Files: null
    EOS
  end
end
