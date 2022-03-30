class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.16.tar.gz"
  sha256 "82cdce84becb2446ae299f897568f52f91bfbea092238b8f58347814efcbda91"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e7634acfdfc69c4f5a78a7a9cfb98adf7738cd10ceb9bd4446ec7cc00c30931"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae18f642c681b2a9b347cc65c1b11037dea7ebfdb21e6a38bbcd6d351e8916b4"
    sha256 cellar: :any_skip_relocation, monterey:       "fedfd59a8ff80b1854076f0a981b7e2f7e76a8317baadb516104bec60fb7fe29"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ccc375fade454957f9303f397bce350bd97f7e84446f16e94289262e5a1fe93"
    sha256 cellar: :any_skip_relocation, catalina:       "571326b3e06a1c3e99c5d6b40646ee8f8621109365aff3ab6ba4cb3b1359c02c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6136e16606ee873b8f3a7ef8485a77108b5e3ffa73c10be225a243092c109d3c"
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
