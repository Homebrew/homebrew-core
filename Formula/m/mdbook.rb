class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "2c8615a17c5670f9aa6d8dbf77c343cf430f95f571f28a87bb7aaa8f29c1ac5b"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c42c5e7429786e9ea47ba92d839976dc048ac60472acd7072e56d771a9148c08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29dae48f7c632b52d97e549bc8ab7afbd74990659c77a2e7d9250424ade0353e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f148fb70abbe80a7e8f091aadfe9e2108c7bbdbb92bf8cb96ed3a2be8b19e850"
    sha256 cellar: :any_skip_relocation, sonoma:        "6893cd40c1e35586fcd686187617e9d978f21ff15d36a5378efdd9e9eae75bca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba01df90430f3f44090cbff536d57808dd3f98d7fbd835947fe9a18c03142b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8adbd5b00a9fa2a25e6f3e9a4239fb7cf271dbde94b2e70e2a1e2281084b8ee"
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
