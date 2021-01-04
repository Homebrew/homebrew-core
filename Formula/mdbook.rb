class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.5.tar.gz"
  sha256 "79fd98bddab8611cae9071aeb327edfcc67b4e449d5653d41d2ee5b04bee3afc"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a6d98eb7767042009250b84490dea3582bd7a811dc2374d616ce602c826eafb" => :big_sur
    sha256 "ec9b64410a5f75aa49360ba15f70695da94e648a216255782935256e10a4bbd8" => :arm64_big_sur
    sha256 "59595db021b9ae3e8a2137f7c9deb740508cf110a3822f49715721d571870b1d" => :catalina
    sha256 "12bd9ff40b7421497209163efb1e802dd3ca08e5b84fe5f5c7446eae0366d291" => :mojave
    sha256 "0671b254178a018b1d5ce8e2d1a880886904ff93caebe3d0867a3a5423e35f6f" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system "#{bin}/mdbook", "build"
  end
end
