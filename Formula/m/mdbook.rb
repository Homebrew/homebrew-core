class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/refs/tags/v0.4.43.tar.gz"
  sha256 "7213c006d78dafa0d7a893bdb8fd3814bbf4d6794ffb97822038185364b73f77"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82c64a936de94fa3c23ebc97c31b1c318ed55fdf9ac31732b4cf89d4f1bb272c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bd3e774e47c76c00a8f0379d5a20a64968862f21b6b1b3b97f18d03f460ede8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8265ffaf0950c8e82fbda6b80e90d13747e99939ed68bfd1d687f09651c2770"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9399a9b16f24e3cabb65200a20a53a9b0448980441d02310de8fb3b4a062c5a"
    sha256 cellar: :any_skip_relocation, ventura:       "e29c7ef941e3bf56eba7798c6d0930453f5b6779c9ac50b04095480805588966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8a96ddf105f1fec0ce2f5998ff61a679237b33d16e2dd4d1cc1cb8d9eb09e3d"
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
