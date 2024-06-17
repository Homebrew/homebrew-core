class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.14.9.tar.gz"
  sha256 "28545d292943197bc48fad1adb647d4fd6019998bff0c9b2d320be55506675cb"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c66912d70bf2f02693fc57be13f2e42deacc9e22122fbae6ed1c84cf5c627550"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b21d55327b1a6e96d97e7d607dab0efd6c5b5efec169a845073375a1db79fe9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbef5626cd3ff032a507b1b9f402fba6dde169f3e7c6762e9ee5c08dac863e4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5721a3333b468ce7ff62dff0cc410ac3f64af607b0d2ddb7b6b3ea249f79a1f4"
    sha256 cellar: :any_skip_relocation, ventura:        "435148b3cadfaf123fc47d8c5bfd3551d1a1818e813d9c3bbe3c9f5df141565b"
    sha256 cellar: :any_skip_relocation, monterey:       "4d56e0af7b9476d8f30fb88618bdc91900267e44f4df2c6eb536b68e0c27df97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83ef64f5d717890ac5c1127934f7db7e31334594cd583b0c21b4a27db6e1fafb"
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
