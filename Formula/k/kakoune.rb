class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2026.04.12/kakoune-2026.04.12.tar.bz2"
  sha256 "ce67adc8af7b20550463332c38e389cacfdd80f709e14b9940c127091aab0681"
  license "Unlicense"
  head "https://github.com/mawww/kakoune.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1ee56c158d482267bfb4c9eb5f2d96e0ef33efbe6516816c9d41c1958451562"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae33d8f505d6f7fd5215ad9f44dbd02e9073934fa93ff63e7103791bd3d10c3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3f49d2965e588dcef96fcbfa88a142f4f97a67937fd43c511c0e12c55d47a1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "77f74b0da3c22963649a16510192d1f645716bcba78a6bd62f7779029a33d7b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12cad1af9c8f3fc3ceb27093bea551ed44d920867943d2c0587ab65a56615f3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b075607361f95116269ae2b1a9fb3356f257228a64add1ed9b445eff75335d6"
  end

  on_catalina :or_older do
    depends_on "llvm" => :build
  end

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

  # Fix to error: no matching function for call to ‘lower_bound`
  # PR ref: https://github.com/mawww/kakoune/pull/5472
  patch do
    url "https://github.com/mawww/kakoune/commit/9d5fb1992e0149130706aa6c9cb3ab474c580597.patch?full_index=1"
    sha256 "3b777df6d6773daeb23cd5fc59a8732fcfbb62294b37c1108ba7e3d8da9524d1"
  end

  def install
    system "make", "install", "debug=no", "PREFIX=#{prefix}"
  end

  test do
    system bin/"kak", "-ui", "dummy", "-e", "q"

    assert_match version.to_s, shell_output("#{bin}/kak -version")
  end
end
