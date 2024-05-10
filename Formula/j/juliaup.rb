class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.14.8.tar.gz"
  sha256 "6c5b3a743f822adc9d0e920d3bad0b116a3ac533062921a68b4f0d1f21918fca"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c54f3467033d9afcb939fdbd2d8a33f1dd32cf7676b08733fc77ea91761f8021"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84e2f65a26c3bee433d9f96334396d7f0b5a5db4155b3025520d49b2355e3db4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd782f2722775beaea6d1047e0ee2cc5f11e6e270cfcf025b680886b0c775e54"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e27c99999ca5b35e3163f1e0b63a71f2ae0bd3383ee6274e1642b0fde1f8d7f"
    sha256 cellar: :any_skip_relocation, ventura:        "5fa44ebbe2c99239395057b72d969636da7752b3c132f945c183c797d45642f1"
    sha256 cellar: :any_skip_relocation, monterey:       "10e892f0275b9cb9aa43ead22c3525f81bd3d7b8e63d76d36ec594f88b6f67f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "749860b0cdf0a77071e3d5b47b05237de545ee1fcc69462bba89935f4475ec75"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", "--features", "binjulialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
