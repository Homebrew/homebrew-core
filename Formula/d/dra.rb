class Dra < Formula
  desc "Command-line tool to download release assets from GitHub"
  homepage "https://github.com/devmatteini/dra"
  url "https://github.com/devmatteini/dra/archive/refs/tags/0.8.2.tar.gz"
  sha256 "5766c57a0e105d9f86aece2b561d59c81fe22d22eb0c9d7cf1c9992b87b2338b"
  license "MIT"
  head "https://github.com/devmatteini/dra.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db4e0a18693fb1805da7d9568dbfd43f446b5568a9af969d38480349a883de24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e43f85a62dfadf61847482bb653570f03653ec576f2c8edc4517235d619a7504"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11243acff417ea800cc9ef567fb81c79f9193e912523b7afb6d2047b920ae75c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed9dd4a0bad66bc96b697a4ebeb3df27d4a5275134968c12873001813b238f0b"
    sha256 cellar: :any_skip_relocation, ventura:       "b683ccde18838772976f1f7fd4751bb138adc45fd939e0ac5f488db5aedcb13b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f94fdae107783b368d609efef6dec025eae5836a864cf97af7cd5c416275fbb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "107c784b4b81441bc850994825e806b104a50a8262c61ecd3bdd2d915d1e16bc"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dra", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"dra --version")

    system bin/"dra", "download", "--select",
           "helloworld.tar.gz", "devmatteini/dra-tests"

    assert_path_exists testpath/"helloworld.tar.gz"
  end
end
