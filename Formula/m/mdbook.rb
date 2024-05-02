class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/refs/tags/v0.4.37.tar.gz"
  sha256 "7a360cb8702d8a35d9db9d0639a6a4650d3a9492970cf772f49c5a99d981272c"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ee71a5cb8bddd27b963b7c5de3c2f3e19acd05a6ace628a07974fb565554921"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "211178ac43219586e8258ff5acde9988df3badcb52ebb60315268240daa140d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "870849a6e3a8f767264c33464c2c119ea004efb7f3ea126a23e32c9c488494c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "44be935503e1a4f2a597340f1cad9d0b4446cd17d0b32a4c4e105f89af3bf036"
    sha256 cellar: :any_skip_relocation, ventura:        "0eb734d6da90089b42ee84cd0786c60f7d485fa5ecdddb32414fd8d10b35ca57"
    sha256 cellar: :any_skip_relocation, monterey:       "cc163aa8986f7e6745abb406485acf67313b58a681e41b6497a78a5919c61b9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c210a406560bf95e1873bdb40584bf1a9a77464212a712695a18c0222507369"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"mdbook", "completions")
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system bin/"mdbook", "build"
  end
end
