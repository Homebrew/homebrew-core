class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "107614330c35c77d53b6f6ce7826c50eed087650efe5646a4d0a16ca6bf5544b"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "650d6e21e22c92f98ad0d3ad005218459cbb73f0856eb204d2ccffff31686d01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6008bacafae08bdaa339a0e92b73d1135c17ef15b3ca9d3434de4b1bea4493c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "895b7ba89fdb08beaaeadcb9a93aa6d4723b5f98de72fb7a5cc720ceaff535cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcb1b25df6635c9d9dbdac3f763d4adff800561c8c10a86910e9cc45062f1378"
    sha256 cellar: :any,                 arm64_linux:   "23b2a3f47df5d6240e889662c3022c2db094bc81e15a7581fc7b0217952ea47e"
    sha256 cellar: :any,                 x86_64_linux:  "c0319317231789859c54ca23c2cae06cd1c37f6b51b84a189f2ae91843d349cd"
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
