class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "59cd17e806a4797e28fa42073c6c8a4d6fb40e28efd7a63f3004d1d738d5be93"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c1051c8b6c17d4f1ee74c266be781cbe83f232e466be6a61470468b0419eab7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "646ede3d09907151067f51d8a286e09693a9af78d49d90b1dfee622f7c2fbf1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdb93992a3ce3dab7e4c1cc431b21a07289fc4fa5854ac07d4cf34475ee601c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ffce1181c000272e9da3d541bf19fecedcd8ae84f264d3918c2bbac1c6e21cd"
    sha256 cellar: :any_skip_relocation, ventura:       "51ab5f33e266d9de917abf79220634b6ef654ccf57e021aea3aaed85f8bac9c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9d56c9d27a7c87f97c044694f2324a7dcf4220df7e41e7fe1ea8ff9eb77d66c"
  end

  depends_on "rust" => :build

  conflicts_with "json2tsv", because: "both install `jaq` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end
