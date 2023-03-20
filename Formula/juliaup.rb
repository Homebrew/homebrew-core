class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.8.16.tar.gz"
  sha256 "99b0d62b589c8a330fffaa2252b8e4251124bfd59077f0789a6a456d3b1ae81a"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da1c55f9412c5591b10fbf038afc99b22327a02de270aa33db5e7d9a954734bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0381288661a78a2d9db4db1b42f251b727e511f0803a7e316b90582e4493438c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39061f893c5c0e7bb68834bebaf843eb855f909e344134c557b0fed926ca6047"
    sha256 cellar: :any_skip_relocation, ventura:        "65876c25691df86d15c58e20d1dd135e845af0af7e65262c2c70f1837f1abf8d"
    sha256 cellar: :any_skip_relocation, monterey:       "05007133b53dba305b75aa9244ef9e8aa30279485e666d4d9dd416c61a67c0bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc3b7753aa29f335c67a869559f0394ebb48e98e5233742c50af748e02c5bcca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0939a4783a13c482928c22c1ff44bef3b6f4651d3629fd2cc240380f7717b058"
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
