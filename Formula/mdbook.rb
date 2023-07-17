class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.32.tar.gz"
  sha256 "fece3b1c3875ab6f99cd9bc98c131a751bf4255bdbe364522512247d105092c0"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "389af2c8fcfae11e8e39696a2268aba66f71b929fdaeb49e40a1a12e3799c3a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c819ced380944487b337490e7c0b282a1c09d2828537e99ecb3630b974e776d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12fc6455b64693c140b8ee455216f436a40f04f05c33ee55e45f3aec299d8603"
    sha256 cellar: :any_skip_relocation, ventura:        "9fe4b223554966a9e29bcdba59846089575c1393632adf1ba04509d1f1c5c5b9"
    sha256 cellar: :any_skip_relocation, monterey:       "25b6c7ccef33f11dd916824207200ce2047b8697387840d859d726c1bbfca566"
    sha256 cellar: :any_skip_relocation, big_sur:        "f013a2fb585ac67d8da03dfb214e580471dd72a6f80683c698c2e4b2cf72bd67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf2876939f2384011a015e3c1ca30699a216c4c025f632b0e121fe0f92458000"
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
