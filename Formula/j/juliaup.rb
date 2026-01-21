class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.19.3.tar.gz"
  sha256 "bf2c0ee50bff0d41db305babecd050e75133f6c61df821de653a607ffa7f5da2"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "556db176d99072b1f7e4cf5780730d4bf21ab01d62f6f67f090e5c47830c714f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14709fd8303d9501e01fb7932c5f6f9c32df9d3aa6b96e2da0e76cde99281dc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11a013f54ae46c5808a5f3e5acd8ba2b3362a0cd651be009f55305511874bd4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c832e7e71507554df85d139dff350c188ce5bce43e318e968640e37a3eefec8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3334d7e009d486e918258f582ea9cf01c9af5c2439be8e662a284296e380016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3a5297148c0bdc306a842eae9ba28e4e8a774f841a60461b41928ddca6d9e06"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", "--features", "binjulialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
