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
    rebuild 2
    sha256 cellar: :any,                 arm64_big_sur: "87457c197389b0e6a8346db08f8b69f544aab44f88cac1c6cf79327422b4528e"
    sha256 cellar: :any,                 big_sur:       "0f94939ffdfce93cdc4f8ab527a36429ad2cdf9a1f42600baad7ff972835ee6a"
    sha256 cellar: :any,                 catalina:      "daa8001d4739938d1b34a09c96160fb0e5e9525b57fa2c1949a2e15cc2159323"
    sha256 cellar: :any,                 mojave:        "f489d4936caeda3e2e6aba22d4db82245cff1291bca5cf93d26a676e7147866f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97f34ea01f31cb9e5bba22b49ae1995b9bcb8c8dd5538c81aacc65b4a2904104"
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
