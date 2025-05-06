class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/refs/tags/v0.4.49.tar.gz"
  sha256 "103a1cae7a8036c81dfce14e8e421ba6d983acc708b52ebbffc98ca544419906"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "960969d153a88ababb2b6c5641af626a65b12d0e0231bdb60e6e883009276602"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e24bca4e21f8e9b2b081929cd2826ba0fd0a29d89dcd8e56287a387ef35873e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45a81039c1530f45e3ae14d6e4a1284cd918aa57ff86bce665f6461a689df8bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "173107c74eca3cfd92636559b2f9649c865b863c0dff12309b4ef83b0ed42cdf"
    sha256 cellar: :any_skip_relocation, ventura:       "083f3528a0b257cb59d85db82da22725bf8e3db181a51dcd6c217825864f4f1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dceca028780cec3fe73cacf73a0d00b14e1793e2de9b39868629dd5566598de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30d858fdfabd2c52ee1dccdd7018aabdeead57b7ed43402da0a5a1df910a4709"
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
