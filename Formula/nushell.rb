class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.60.0.tar.gz"
  sha256 "9b9deb8e42cf18ccf328833a4d051fc14cef0be468afc3b0dbde6657deb9f079"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64b24a822ad3c09a4481af51cf19e1a7532399cbdfc3e19cc8a29015de06872c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a3bce259ae68f117564fd5a746843cc0c50da78a94b8d74b6756cb236ff944d"
    sha256 cellar: :any_skip_relocation, monterey:       "4192c56a39fd23579e815ced1772b8db552507ae9d54258d148514c00e74c151"
    sha256 cellar: :any_skip_relocation, big_sur:        "b01ebc7d70dfe1c9690d8c5836f227257590677b516a4e895493c6b0223dd6dd"
    sha256 cellar: :any_skip_relocation, catalina:       "504733ac6f442e0074a4689f41d055d34ddda098dd28715d53902dc29b60c5da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "039998dea01a8574ad4eb42c76e5e89c93306244df3e399a49e8698fedf85f2e"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "extra", *std_cargo_args
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu -c \'{ foo: 1, bar: homebrew_test} | get bar\'", nil)
  end
end
