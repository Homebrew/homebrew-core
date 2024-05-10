class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2024.05.09/kakoune-2024.05.09.tar.bz2"
  sha256 "2190bddfd3af590c0593c38537088976547506f47bd6eb6c0e22350dbd16a229"
  license "Unlicense"
  head "https://github.com/mawww/kakoune.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e85e331c04cf773feda8ece51ebd99753a0d656f212919f6774397a9cc812607"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae17a66d43bcee76b92d42f8f1518175367470914c0bd2dea964ee69c1dcdf6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "098b3b44451afbd4ca54baa03128c07a9c822e639178ce7bb5fe00815a125e97"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c164a078644d9932cb9ddd5924734c825f68ae19dd1b6b114449a82d1591a01"
    sha256 cellar: :any_skip_relocation, ventura:        "287566a78b179e5926ed07a394a5e760f3e09b6d1b8a8e9707c6d2b1a4b2d493"
    sha256 cellar: :any_skip_relocation, monterey:       "5ec7421d06d5f8b1d2ec60574023a893a5b4244640c8123b0b878e4cf166410d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ff37e3e6928fa463beac4337e21825131a157bf837e320bff49091e56bef734"
  end

  uses_from_macos "llvm" => :build, since: :big_sur

  on_linux do
    depends_on "binutils" => :build
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  # See <https://github.com/mawww/kakoune/blob/v2022.10.31/README.asciidoc#building>
  fails_with :gcc do
    version "10.2"
    cause "Requires GCC >= 10.3"
  end

  def install
    system "make", "install", "debug=no", "PREFIX=#{prefix}"
  end

  test do
    system bin/"kak", "-ui", "dummy", "-e", "q"

    assert_match version.to_s, shell_output("#{bin}/kak -version")
  end
end
