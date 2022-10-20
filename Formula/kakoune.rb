class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2021.11.08/kakoune-2021.11.08.tar.bz2"
  sha256 "aa30889d9da11331a243a8f40fe4f6a8619321b19217debac8f565e06eddb5f4"
  license "Unlicense"
  head "https://github.com/mawww/kakoune.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5092de013e5a673a4d1e5f0576ad48ad98175f75269c3860e906fd4ddb16ea0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6702288ef929636e9cca45f49d59bd2bdfc48b62a163163d3186bb32560f4e28"
    sha256 cellar: :any_skip_relocation, monterey:       "402fb3821ccb65bab8d917d70c69aa372b59f0649b30b1655794a4e1b7495a94"
    sha256 cellar: :any_skip_relocation, big_sur:        "bae4c38b2ddae7663e0edb080b8725fd4811cd90823d7c26610726b26caf0155"
    sha256 cellar: :any_skip_relocation, catalina:       "0620ffadba67da01ce4944c7514533aa1b2591a5ef006e33a196624c68e3035d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac5e0f28176c38db9527cb6b7cf0f560e43e5d8cffd0e33eb00ca4bc4cd0f7a2"
  end

  depends_on macos: :high_sierra # needs C++17
  depends_on "ncurses"

  uses_from_macos "libxslt" => :build

  on_linux do
    depends_on "binutils" => :build
    depends_on "linux-headers@5.15" => :build
    depends_on "pkg-config" => :build
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
