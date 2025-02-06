class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/refs/tags/v0.4.44.tar.gz"
  sha256 "af801a377aec2e671e6c6fe5ed3043c3e8cab674cbaa0a2faed36b8b6987ce10"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34378db91ea5e0831f976572caac3b874d205caaa52d53583840018131f3b2ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5a521a87906acd305db1ef23f94335d061edcefbdf22baee58507e7ef1d4fc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c974b4eb16bd3cd369b2d6e14aaa0cfd051843c2c7610e07b0c8d515ffc037f"
    sha256 cellar: :any_skip_relocation, sonoma:        "abceb2eacaa7b89fb7dd79456f96155b4715f11f74ac75f7a37792d77c3e89fe"
    sha256 cellar: :any_skip_relocation, ventura:       "042e10f8ace2c63b6cd8fc7787f99fcec05a1ae0111bc92f373f8509c6fbdf49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e470337f0a2d92d90492213ffc42df5f5e0c07c5da46b0bfa92b0749ea84699"
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
