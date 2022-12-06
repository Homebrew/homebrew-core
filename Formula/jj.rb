class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "6b6398f3626459bb57bc99705b6c86fe2b435a16faabf77582a8f6a7f92d50ee"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e9760df51a3d7460c0c67664205c4f1240d6c9df6537fd365f646a76c732cb2d"
    sha256 cellar: :any,                 arm64_monterey: "ce2d23e08bb0dabe40d0d94c00c9ada38fddae233e6597883d758a8ccd5716c2"
    sha256 cellar: :any,                 arm64_big_sur:  "0518c08612a67e23ef77d9f7a882b6e9f3d4e913326492ab2623a409814c02c5"
    sha256 cellar: :any,                 ventura:        "cc3d2f4a9ad6c9f83e4652fdf4d9b943f53d4ac047bf2f73aacc165c3493de81"
    sha256 cellar: :any,                 monterey:       "d222058c9b1fa337c4ce3d0cc08bc05bc7e26bd15749c9ab4d8223b882467cb6"
    sha256 cellar: :any,                 big_sur:        "1e84ce8e4e7f85628e93993f4f5467f02cbab1d29d3621ec89750eb58c53e3b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13f8c896f8d2730fc7c177c4ee51818ff848a8480096cd8b76b9c132a4ae00c3"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--no-default-features", "--bin", "jj", *std_cargo_args
  end

  test do
    system bin/"jj", "init", "--git"
    assert_predicate testpath/".jj", :exist?
  end
end
