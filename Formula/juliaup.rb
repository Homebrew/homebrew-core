class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.6.12.tar.gz"
  sha256 "6d3aec6f82de22994e38137258603ba51fc6280b292edc31f9542f990fa741ca"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1caa1bd432e43d6fe7a38fabc5f5d4e4130e2b75f2fc8c1a00211e2d0f82b19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "863c1b82759459e16fa09602a7e620ae44c4b8291396c748f0f0c24a4011c6e5"
    sha256 cellar: :any_skip_relocation, monterey:       "a3e4bd8af82e9a527fdaad6379a2ecc99acd01db25afebeff907905b9960ca9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "02a0c047be696f0ff642956fd885db6ef2fa394dda2cde5a452b11610f0f1a35"
    sha256 cellar: :any_skip_relocation, catalina:       "461574151e289cf620b826e65696f7a6be8e8e9c48f0e053f4919ec418464c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfdfcb1ac7d798deef5316665d89fe907946f0a639c6cfb6db1a4f8f7da0bd49"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
