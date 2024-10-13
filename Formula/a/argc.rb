class Argc < Formula
  desc "Easily create and use cli based on bash script"
  homepage "https://github.com/sigoden/argc"
  url "https://github.com/sigoden/argc/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "d46c0ce07c4ae7c2a01556842e09884ccf70adbfae5354f831cfe7a70cf7a2c4"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8012bb90f3ae74c4697e88bbea7d121d771565a4420fc35e645ec9096375562c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "394874707693f4abe3b9d3e7a9d1b645fc9bdf8120c04ea68ec61b30ef2b08b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0286f8170906df35ddc02e9be1ad4fb2c37b566edc598cac1dc37ecdb64c5ff4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "287c3c7db3a9fef28fa02c8d09c1bb18217f52dbd7db48f9b248d1514610930e"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdc7da6917e04cb62570b94d977203657cba75f46fed2c0766d3000b7a535a23"
    sha256 cellar: :any_skip_relocation, ventura:        "883890699261800b37edb30327238afa5001cab1bf3bf1302863bf1bbf6d211b"
    sha256 cellar: :any_skip_relocation, monterey:       "115e207d65095fef271b26f89011c2e4f72b1d0389a593ab0df733cdfd7a3e7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b475259aec9f56bdb89455201d22683c99aa5d86ee9fddd801b9c9ba1aa7a016"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"argc", "--argc-completions")
  end

  test do
    system bin/"argc", "--argc-create", "build"
    assert_predicate testpath/"Argcfile.sh", :exist?
    assert_match "build", shell_output("#{bin}/argc build")
  end
end
