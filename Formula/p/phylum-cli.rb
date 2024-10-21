class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https://www.phylum.io"
  url "https://github.com/phylum-dev/cli/archive/refs/tags/v7.1.2.tar.gz"
  sha256 "5ea515853a1a621c28a61fff5e9cba08009602aab5b5fac1ae09ddd68e1f6646"
  license "GPL-3.0-or-later"
  head "https://github.com/phylum-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93145ca2a04a172d80f3a05ab21f7ce45c89f4b3c881bd69fb33801c45c053cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c128b3fa693e1b8a24843883516f88eae84b47a41b275d05b041c9562fbc9966"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e21ccc07e0832f99948d665d1f0bae3aec02f52480fe7022bd74aa3401f28065"
    sha256 cellar: :any_skip_relocation, sonoma:        "0db76c4789f9b587b32de26be329db74ea29707882029cffed55c18effb4d16e"
    sha256 cellar: :any_skip_relocation, ventura:       "6875ee6e9c4213576c2d348f1691d01523da1471e298387fdaf9885097b96912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b507dcef4cf624b457cc08d2460020a74dbfde45f15a9ca644ffbda4f08bcd5"
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

    assert_match <<~EOS, shell_output("#{bin}/phylum status")
      Project: null
      Group: null
      Project Root: null
      Dependency Files: null
    EOS
  end
end
