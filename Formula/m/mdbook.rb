class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/refs/tags/v0.4.48.tar.gz"
  sha256 "65021ceca2a2f5a1ceda243953ce764bf34c466b7a83db38e167a2b7d1131dcf"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13746862cd69b81e8a26c110459dd3a8e1de751ce5797b9cabd9b3e433b04cb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2efa019012b24ca8e34b94a269c834b0c4f548cddfbb4dc43fb520b685e50f00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f345249436067c6f0b558c211ff9624c6816d0bcad0776d5b1c0772906d77f72"
    sha256 cellar: :any_skip_relocation, sonoma:        "81619d3a17c4d92df33b8cd6fb6399ec71a13a105d4386eca4b1ed3607f2d25d"
    sha256 cellar: :any_skip_relocation, ventura:       "379ba20e9e11c9f9f8bbf4f24517ef77d40c08775f05666bf0ea54855ffedb5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b50a19c4429a016a0f1147d2ef9098d89bada83b89ddfea8b48f1ffbc094c26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3f05ebd5bdcdbb808c2221e0a9b4a76125aee39f5eaa5ae684c6e142f12d123"
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
