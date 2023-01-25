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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6433e00227d299986ab1bbff1c41c9bcf8ddbaee825085ff3ab62cde72e377c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f31a1765a53309f42bdef042c82b8510aacdeed47e4b5563457c6a2e91fad7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ca17ff96ac28cdf3aa24317f6ddce22859c82087bff76d06a1f911948fca3c0"
    sha256 cellar: :any_skip_relocation, ventura:        "ea0a3df04f0d8ad2ba262d0208ba8910e5cd728bd13044c39387601f0f401d04"
    sha256 cellar: :any_skip_relocation, monterey:       "bee2f0c9c8d1f57f366d4d3452f9bf0d73e30509a651258d877311dd2733f4fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d49c03712e4b2e60d2ef91e14afa838552b4877e5a42121d6147443c307380b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "606496e883548440a2813b00e3639212da5d3aa11a52d4fd9ae180d373197fc5"
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
