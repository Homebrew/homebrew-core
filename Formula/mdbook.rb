class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.16.tar.gz"
  sha256 "82cdce84becb2446ae299f897568f52f91bfbea092238b8f58347814efcbda91"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce829c6916e6e0e92b87fc7b50d32717e425a34daeb599e91de63e82490139c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5567150ceb34975ac1410a06d36a92652e37ededcf77bcc1487afe77b9669ec"
    sha256 cellar: :any_skip_relocation, monterey:       "275537af633a8a359d7109a0777c535ae1b2e36a07566c49b021589e8a8bfcf5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7ea2bc7a6bb74fade5123e1e4523e1f49addca4730b5e61d66bb13feddf2e83"
    sha256 cellar: :any_skip_relocation, catalina:       "a8a40fb27378a45e8543072fdb73036e6977d634d3d974834fa1208daca054a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e8a47e663ef70129e878cff9c43336e37d50739847cd2222995fedd5b684bd4"
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
