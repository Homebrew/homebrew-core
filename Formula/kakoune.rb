class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2021.08.28/kakoune-2021.08.28.tar.bz2"
  sha256 "6f6ed7dfd8c5723210dbd848708acf03af4b847016fd3ede96b2a89ad32276cb"
  license "Unlicense"
  head "https://github.com/mawww/kakoune.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cf56529386ac094bf0cefac9c50a60a7234127c9d1c3ed22e853f8cf917dee91"
    sha256 cellar: :any_skip_relocation, big_sur:       "6fdb7731b67b916f43c85d1674982a5801af161878446eba999de72a492e586e"
    sha256 cellar: :any_skip_relocation, catalina:      "cdd59d3c8978b2c8f2ca0899867be322ce4d23eac3600a3b0684e199d5020e42"
    sha256 cellar: :any_skip_relocation, mojave:        "af3a8f431b72c684b26bbbd115bf08ad9d8c12b95e83f7c0cea3f8881946d6a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9797d57cd6184e1b12a2c6120ccbfc51bbb369cf932400c0e556d0f9074b5d8e"
  end

  depends_on macos: :high_sierra # needs C++17
  depends_on "ncurses"

  uses_from_macos "libxslt" => :build

  on_linux do
    depends_on "binutils" => :build
    depends_on "linux-headers@4.4" => :build
    depends_on "pkg-config" => :build
    depends_on "gcc"
  end

  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    cd "src" do
      system "make", "install", "debug=no", "PREFIX=#{prefix}"
    end
  end

  test do
    system bin/"kak", "-ui", "dummy", "-e", "q"
  end
end
