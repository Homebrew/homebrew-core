class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.12.tar.gz"
  sha256 "d28b958c71a7934fde1c22204c3dc41ffc74df98c90afc1bf3ddafd131d4af77"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b9f487d2c7f7f2fb65cc99ceced811a4170453d8bec0c7d60cec717a0f3b53ca"
    sha256 cellar: :any_skip_relocation, big_sur:       "32743f10b38d4a421e87fbc61773abd08f8b286d35e77797c0fecb847f845896"
    sha256 cellar: :any_skip_relocation, catalina:      "0e3250f1ba78dd8d4da7876be308b784df527befa88eb96e4fc900722d4a2723"
    sha256 cellar: :any_skip_relocation, mojave:        "83def6375e138ef30407d0822f8af2f17c465be4159eb27fc508a7074aef9057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8521b42392591d9ca3940f5984279eb33f6cf716b20475b141587cb864a2ac94"
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
