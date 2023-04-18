class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2022.10.31/kakoune-2022.10.31.tar.bz2"
  sha256 "fb317b62c9048ddc7567fe83dfc409c252ef85778b24bd2863be2762d4e4e58b"
  license "Unlicense"
  head "https://github.com/mawww/kakoune.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "771d79380fd9f1cf319e5e855b5218c33eae4d5c19ed7884710d7b596d2db1b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da6968f945e5f07e97e63cbcc91b664dcd88c0d7e24077f6a0ce3663d185922d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "805deb07df38ad4f5cb0f79d3898962d663fb036972d7b68b4fb584fc8a456b8"
    sha256 cellar: :any_skip_relocation, ventura:        "1d6d075af2af9fe2641232745ce68f83ca56f84d2c98117702df2f93e7faaa8f"
    sha256 cellar: :any_skip_relocation, monterey:       "04163a55a1f74fa8c16eb11b26baee11ca7729cd4d6439c251db964fd8df7606"
    sha256 cellar: :any_skip_relocation, big_sur:        "fae1f0775f82b821689516906464b2502807736fa9048d691f5d1bf2742b47e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e008cd070d41894c2633d4686bfda79b5295d06b2352bd8ec4dc2ad4df799df"
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
    cd "src" do
      system "make", "install", "debug=no", "PREFIX=#{prefix}"
    end
  end

  test do
    system bin/"kak", "-ui", "dummy", "-e", "q"
  end
end
