class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "69502ea3b5d96bb17114a3f1da3e1615e55b850bbd48dcb4f60c7a5b78cfb7b5"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4995a4604edefc7ac8d524c16137d2696cbb996c82e89efffa0b51db9d46f4da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e60022e095a855b76d6df73cc7efb06e56d0e6c9fd3d0810dd01d9961b6f074"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a58e3ffd7216434a6c16d801b1ceb5329f145d232a0e263c11f1eebb7845bd1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebbe922ed11942a333cd49f51d885f2b873df4933fdaf7ac6e18792275486f1a"
    sha256 cellar: :any_skip_relocation, ventura:        "633f870663009e96e0e5fe8f8a969ebbff565f63be7085929e81fe9ff2973562"
    sha256 cellar: :any_skip_relocation, monterey:       "0d3b28cc1e32b2a4c7008b2c354b3f243da71eef09c50d167f95a2604c972f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d02222402058164329cb5031386c198b0d077f14659259734cee9b0ecf862d9"
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
