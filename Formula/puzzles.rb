class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20221125.5a2ea91.tar.gz"
  version "20221125"
  sha256 "fa9c445621a6661b2caa206f34107cf57e2441bc8fefa054bac31d83a9eee23d"
  license "MIT"
  head "https://git.tartarus.org/simon/puzzles.git", branch: "main"

  # There's no directory listing page and the homepage only lists an unversioned
  # tarball. The Git repository doesn't report any tags when we use that. The
  # version in the footer of the first-party documentation seems to be the only
  # available source that's up to date (as of writing).
  livecheck do
    url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/doc/"
    regex(/version v?(\d{6,8})(?:\.[a-z0-9]+)?/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c785e8c5606fe118114613b948399db6ad7b660ae29444929c2e5208fdd71e8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78f0a52561809c878f5c49cde64f7a8caf1aed85fbeeb77aa9ead1490a4543b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0831b9d042b9b21fb850636c84d4aea6029cd2471edbd9e2641a6c0436955b49"
    sha256 cellar: :any_skip_relocation, ventura:        "398d7f283e52420e819a68e6dd2235fb66f6c4a9d58561f77b144d58d8448056"
    sha256 cellar: :any_skip_relocation, monterey:       "8804e6df9c595d861cf58b317b273d3af42f7af602ae7e1a482b1ad82c258cf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "762698042785994162f6721c20c3ce83257ac85744de4e2da36ab900e1e80162"
    sha256 cellar: :any_skip_relocation, catalina:       "8113e5f35b866c08222c99bbc2a84f2afab479f47e00d2cf13cb864d369c9529"
    sha256                               x86_64_linux:   "c528add9c7ee6065863583c98496fbcb61572fa124c6c7b726fbe8bfec8eb0d7"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build

  on_linux do
    depends_on "imagemagick" => :build
    depends_on "pkg-config" => :build
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "pango"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    bin.write_exec_script prefix/"Puzzles.app/Contents/MacOS/Puzzles" if OS.mac?
  end

  test do
    if OS.mac?
      assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
    else
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]

      assert_match "Mines, from Simon Tatham's Portable Puzzle Collection", shell_output(bin/"mines")
    end
  end
end
