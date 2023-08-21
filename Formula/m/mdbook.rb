class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.34.tar.gz"
  sha256 "6d0542a1bec4f9841552084643c11f104472646fc82a280a07fba05ae2df4602"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcb47846273bfa0ecd0f24b947cbb2aa6ad0b1d96b7cfe4be51671cfebfe7581"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "640f89162c941188019cf5f3d97366bf05129fbfff4374028b5901d0c19192d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6806455336ac7924da489355655aea136730a9d08e6061aa15b3885adfbf3667"
    sha256 cellar: :any_skip_relocation, ventura:        "bac6b5687411182ec3c25f31bae527fceec6c3eba45be29d63e8826a6a843a1d"
    sha256 cellar: :any_skip_relocation, monterey:       "290d52e71a25c4946235ac1e55576a71e5a7dc502b02927061dcd04b8c1c4ba9"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd465fd7fe5eeb0a5250e77bf77efc4d2d5ba271e40dea7ea06a889e3898f818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c5d997142e42f78df0b1ca32147459e28abee14df2053efe27f5cb679aba20c"
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
