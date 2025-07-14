class Astroterm < Formula
  desc "Planetarium for your terminal"
  homepage "https://github.com/da-luce/astroterm"
  url "https://github.com/da-luce/astroterm/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "d7205aeca4a8de372938b103c4ed787a8430150f7d4254151e2148434e9d4430"
  license "MIT"
  head "https://github.com/da-luce/astroterm.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "99f81b7da706b83444d9f91a70951e8c8c451ffa7c28a81a326ff413e37a1e61"
    sha256 cellar: :any,                 arm64_sonoma:  "fbfd849cf08a79e83ec02260e5eed1a1f38155e09f6fa17d2f353a223d4fd503"
    sha256 cellar: :any,                 arm64_ventura: "4c42f5ef0e2fa0f058d93a23bda78c572deb1e5d97f676b887285a431f8c2c57"
    sha256 cellar: :any,                 sonoma:        "56b8ab6de5657f4d51549844c0419a5f8bb08cc7397565d1fe08d02896b5875d"
    sha256 cellar: :any,                 ventura:       "556693ba90ac8672bf382eb4a903d76897132cc0fe29f0617b6f84ef0e81dd38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c84278cb8e72e5c3702bea197ed58cc5b39d73c03f10747e2afcd94e51725b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "144cb5a9c2b1095580278ff0a2afa052842d6a4a867ac6cb6e05769ae82795d4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "argtable3"

  uses_from_macos "vim" => :build # for xxd
  uses_from_macos "ncurses"

  resource "bsc5" do
    url "http://tdc-www.harvard.edu/catalogs/BSC5", using: :nounzip
    sha256 "e471d02eaf4eecb61c12f879a1cb6432ba9d7b68a9a8c5654a1eb42a0c8cc340"
  end

  def install
    resource("bsc5").stage do
      (buildpath/"data").install "BSC5"
      mv buildpath/"data/BSC5", buildpath/"data/bsc5" if OS.linux?
    end

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # astroterm is a TUI application
    assert_match version.to_s, shell_output("#{bin}/astroterm --version")
  end
end
