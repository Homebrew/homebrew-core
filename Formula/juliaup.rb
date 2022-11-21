class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.7.27.tar.gz"
  sha256 "8421f65512bdb50d81d672730bc1d0f88e4c31f6b10619e0df4a8978208d3187"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f440b533562cc5fc81f52272206e2b28e79b3ec174895fb8322a193dc39edf7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1b060ab139b7bd5a01d6a258eb6589bad591babdc6b4d11bf5a930d8c89ee48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf3841af1cb20221e51271f7355dc84c0ccc49c8786e7552a49d4ac3921bbba3"
    sha256 cellar: :any_skip_relocation, ventura:        "00e4a197fe158757651c95c88e45df1cc13641b65778696605618ae4b61a4e8c"
    sha256 cellar: :any_skip_relocation, monterey:       "26ad8bbf8a9eaa875cd291542d3ef1de8be9613f9de6fd7d570d44ff113c13f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed26cc7f35010273b06ad59532d5641c47b5bf59ec196f9412a3c284e8bbcfd7"
    sha256 cellar: :any_skip_relocation, catalina:       "81cce6e1c26aa8e8f55d8fe162f14136e2784657cda201841ac187992ab92f82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f63a5c84d486c63f8636bdb63f98a710fc65fe644fb6f4ee8c0b3d17666c7bf4"
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
