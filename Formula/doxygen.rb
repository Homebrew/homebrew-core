class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.org/"
  url "https://doxygen.nl/files/doxygen-1.9.3.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.9.3/doxygen-1.9.3.src.tar.gz"
  sha256 "f352dbc3221af7012b7b00935f2dfdc9fb67a97d43287d2f6c81c50449d254e0"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd1c00d5fd57d5802654c303ba9d7c3f3951d2e74b384ab106172428a031180e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37487464a76f3fb3831e99a1da8e36730e74394beae43b245e1a7442910d0d53"
    sha256 cellar: :any_skip_relocation, monterey:       "1c57103a32256859cd79711105d80018de29a77d12475c66e7ed548cdbded1e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "69c69a7105b8e22992ed19ac505a026fb3446924436f54f2a5be48f6abf93298"
    sha256 cellar: :any_skip_relocation, catalina:       "69fd14aae993e7a48240a1c3fae8d7c14b23e8068ffce313588c4a50a6453247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2aee78dca571810183f92dca5d693c36fa1119b809c173655214d79503c04be"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "gcc"
  end

  # Need gcc>=7.2. See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66297
  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
    end
    bin.install Dir["build/bin/*"]
    man1.install Dir["doc/*.1"]
  end

  test do
    system "#{bin}/doxygen", "-g"
    system "#{bin}/doxygen", "Doxyfile"
  end
end
