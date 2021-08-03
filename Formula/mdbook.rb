class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.12.tar.gz"
  sha256 "d28b958c71a7934fde1c22204c3dc41ffc74df98c90afc1bf3ddafd131d4af77"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "05c23b0293aebfce8ca112e22c260c9c3a0a8a0ac463af3cc10f29aaff1ef4d7"
    sha256 cellar: :any_skip_relocation, big_sur:       "da73f15b2b1c33597848b3d03e7738ae84991509ee3d253d70ec5a384d960e8b"
    sha256 cellar: :any_skip_relocation, catalina:      "88cfc520285edcdb8dc39ddca990a5935556ef41ba6eff3f7e74ea4fef0d7967"
    sha256 cellar: :any_skip_relocation, mojave:        "bc7d5edec9d4828f00964e5c95eb3de83c684713eaacd79cebdffb00769cb678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97926e444112d5a750860ee75a0e5e9a639a84fc2ce9475cf557404715d3bc98"
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
