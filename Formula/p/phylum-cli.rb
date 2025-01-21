class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https://www.phylum.io"
  url "https://github.com/phylum-dev/cli/archive/refs/tags/v7.3.0.tar.gz"
  sha256 "8384841e47b7af39fb9501316b65908a0bce458e8721cf84f3d6339b2938bb41"
  license "GPL-3.0-or-later"
  head "https://github.com/phylum-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca60efb4f8c44c4613aa5f3d85f9e2ca601edff87c4bd5e9834604ca52b99b43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e560ece29541ebb903ab20b7a21821855b8890d56d6c626bd61dbf8a79fb6b28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "902c2e55337cf81f5d013871d348ca0f718b29f78937213987d8563e20e6d218"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1802fc908f5f6ae4418f53492a39aed96667ca208db98f8575249b726e1998d"
    sha256 cellar: :any_skip_relocation, ventura:       "8ec5fdf53567c7afa18578bfe86840e454d33368c1f7b9b6a2941d3d7f0d4c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a6a728023b823f5f41b3776ef61326263444d1c964fe80d6f18eb3e444bdcbf"
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
