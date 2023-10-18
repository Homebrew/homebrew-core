class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.11.22.tar.gz"
  sha256 "8a0b4540262a8bea9e61a4f287ced32ec4ad2ac4cb528a1b473eea6f139256df"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef1ea96e01e08fc181779ea1d52f8ec2af851462b7837a2ee7557f95ded6bb66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62612166c99ee481b315dbd7818b05c59dd0300aea5c383bbcb554ea56b5e1e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ac9c072d4e8bdd390c87cd27c5518cbf7c7b62c23e75e8db726cb01d345176e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a2796a4550575d76741de55203e9e6159206b67515eb054cd32a5e6d0e2bc3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "df91d4ad57e30fdd3f5d15ab9fbb3e3ee61f3cd7a90b8bc12531003ce4757dd8"
    sha256 cellar: :any_skip_relocation, ventura:        "49dcc9990817251b6850cc1201c61f1c07aadf5122a3b19e88d852dc639134dc"
    sha256 cellar: :any_skip_relocation, monterey:       "658d83b029f3f7ea09642f4457024faf15c3edaaa71421ffa1871c7e1c177c46"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d8a814414ce16253382f9b6723583c3bbfbb2e846ab9230583732df59d8488d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0edfd0e3b8e99c0796d47532ef161f01e63a4de76e92e499ae43caf8c9f71593"
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
