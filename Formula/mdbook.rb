class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.21.tar.gz"
  sha256 "17385837070c6a312eae4717fe0bfdd259ce07b4b653b5c258b4389062df886d"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "465d2ec3622817ef9adc55f645e41b58288872011457f97fa79220aa17ba806e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dcd18d5e2a6e9d880e706ec4a3ca54b4b5409a07adc908d1bfd6440dd0c7cfd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1605e5ba8de3b0336588c1396ff18673bb342317d09b69617a4ccf53136fb25e"
    sha256 cellar: :any_skip_relocation, monterey:       "7d4b2206454179f81a48ad308d3265b0d20ca05ddd0b3c6bfe219cdf03f75b5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "075fd9fbe39fa53d5a77b89012b08be4dddf5806eb7fb52b1a5d18a2e716ee8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57c0b2a679e4a604f8830bbeab685ef1a2e425958cb12b145d90dbb19705a16c"
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
