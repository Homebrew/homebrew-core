class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.17.tar.gz"
  sha256 "9523d0bed63ce35eec5a8259eb963651cd7e37ec5644ef551134068a2fb72f89"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3db21a9ca3be2770634e96acd3c39e98b7c1f495a2a70b6b766e7f5df3b9c433"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abd78e4e2b8e1eb9b0f91dd4746c6263f0352d8a288e6542fbea8553ec158857"
    sha256 cellar: :any_skip_relocation, monterey:       "7a26ec5c2c205994f92617ee25f69534abd435c2045498f4e448ae030294fb26"
    sha256 cellar: :any_skip_relocation, big_sur:        "c08382f2985be2e30cfd6d0b977d45d3c022db5efa7489ad1958fbff40678938"
    sha256 cellar: :any_skip_relocation, catalina:       "fee2e3704a9426569d18a2bd18709373859d6b611bd1a80300253e3c0461b506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "101afb2b2ace0c904a83bb50f161f2a3b5bb651c25d2c5072ff975c5ea7cf84d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system bin/"mdbook", "build"
  end
end
