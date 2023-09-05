class Frum < Formula
  desc "Fast and modern Ruby version manager written in Rust"
  homepage "https://github.com/TaKO8Ki/frum/"
  url "https://github.com/TaKO8Ki/frum/archive/v0.1.2.tar.gz"
  sha256 "0a67d12976b50f39111c92fa0d0e6bf0ae6612a0325c31724ea3a6b831882b5d"
  license "MIT"
  head "https://github.com/TaKO8Ki/frum.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cddc04b3d141142ed2e7233298953fced064fd66b195bd3a61f7777dcc38cf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f013c9e0f93e9d4b50ed47d2697b5c3b1cae50386e0ef791cb0ba759647a958"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e31935129068c2c8c63726fc533700200611551259511f0e833f0a182fe0ecd"
    sha256 cellar: :any_skip_relocation, ventura:        "ea5e5f6db4179f71c7e16d0defb206c95e7bc614af06332e3bee4c1e64ed9c7f"
    sha256 cellar: :any_skip_relocation, monterey:       "9da3203818c248c1921c49923406b6f96b65ff9ea0ee5cb610fa5d3f18bf0cc8"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0e50ca3dd2d7e5db5f553d960ef3360a8aaca91c1668a3214e83c7573e28020"
    sha256 cellar: :any_skip_relocation, catalina:       "edddcc88716948addb74667dd7c9d2b0918b582a1f631ea26eaf56049feb0e11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3519654e6f824c3528b8d574d59a08b316821122a043727f633a70432dc02d6a"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"frum", "completions", "--shell")
  end

  test do
    available_versions = shell_output("#{bin}/frum install -l").split("\n")
    assert_includes available_versions, "2.6.5"
    assert_includes available_versions, "2.7.0"

    frum_dir = (testpath/".frum")
    mkdir_p frum_dir/"versions/2.6.5"
    mkdir_p frum_dir/"versions/2.4.0"
    versions = shell_output("eval \"$(#{bin}/frum init)\" && frum versions").split("\n")
    assert_equal 2, versions.length
    assert_includes versions, "  2.4.0"
    assert_includes versions, "  2.6.5"
  end
end
