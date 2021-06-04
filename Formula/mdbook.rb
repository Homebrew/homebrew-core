class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.9.tar.gz"
  sha256 "f796e61f3788d256155857c4aca340ae745d7c527e831671366724d30c599d78"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c9a6fa2a07d0af22fa2da3f35d4aed9fdcf933cb947092ac91d222ac7bafafa6"
    sha256 cellar: :any_skip_relocation, big_sur:       "f6fed365862fd72e7f4382fda44f20f228ea80137f329933255c2c675b5edd7d"
    sha256 cellar: :any_skip_relocation, catalina:      "c1f37fc452e14f8a0d65eb5e45afa9017d4af7dea1f7ef2d0aef6d032dfdaf71"
    sha256 cellar: :any_skip_relocation, mojave:        "af50d0d82ab27cd6426fdf179fec72084681b1c04ad39bc11f5c751289f34f9d"
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
