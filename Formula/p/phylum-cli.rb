class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https://www.phylum.io"
  url "https://github.com/phylum-dev/cli/archive/refs/tags/v6.2.0.tar.gz"
  sha256 "abeb3e86f2b41060057c4f10f9fb5fd281e6739946db1c11874e50c131dc0683"
  license "GPL-3.0-or-later"
  head "https://github.com/phylum-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4b765298ae9059b6ca983d0b8f3fd5691dc8fa3a5c6f8a7507563d150ae0169"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "def3f18e7d43c2628d8f9b971e0b4c896df0ebd9c3af84982fbb8c95f5402d44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76e2ac61c914ccdf48e765937f30cb6bbdbd634e99d491b1e7872ad03a3870f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e5f8e1f60e3cf796eee788abfb5a8d57ca022efcc2c2ca5c24916dc384718f9"
    sha256 cellar: :any_skip_relocation, ventura:        "450eb2292e5266b47f3dcd616051d06e43e0b2b6d8cf85e71486ac4b693655e9"
    sha256 cellar: :any_skip_relocation, monterey:       "36bf59f8b903c28a8c302ce0b73fa081f4e0d0e53171e8c582262275e86c2680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91e3b9c8877441dd8e6a548a103aef318537ea86d7583c742dae2f5bedcb1a1d"
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
