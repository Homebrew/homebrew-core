class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.35.tar.gz"
  sha256 "2fcefce12acc957c1d604e60c309502b9ec37040f6f70656f12c81374ff27bd4"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99ff583b69863a2c828632064df10172879d677dc003b902de36403028e49e1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a7e1322508868e4a4372d74a00ab72b1e50a9c612725b4cca3a7a3e7be3496d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8704bf0ef941476af81c1d1bd767d5834cd73336816afbcba005fcff24ea4e4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d189ce2c20afd1f58cd10fbba59a9d48df54f56f3b3796f6de608a5dce8784d"
    sha256 cellar: :any_skip_relocation, ventura:        "7583935b84da11a9c09b7d5dc7922229a5ec58a142747e99e94a3bd474e140aa"
    sha256 cellar: :any_skip_relocation, monterey:       "90e708a6945c26002ca881b73621a61241ca86261d32acc51e26074c32cbc35a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d9037ed8316fa76a36395cd7ca84697ce16a960fde44e71e262fbafdf8673cd"
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
