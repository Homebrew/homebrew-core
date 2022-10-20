class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.21.tar.gz"
  sha256 "17385837070c6a312eae4717fe0bfdd259ce07b4b653b5c258b4389062df886d"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f27390977f9b377fd9845cfb1585f6d7d2795c4f208a360e8697fb41ac47a20c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa2468366fc57c90d36438e2cc74ef764090e3f1f399a0fc47e6fee47e750fa1"
    sha256 cellar: :any_skip_relocation, monterey:       "0666ad3aaab9a3513d99eff2a7c9ad7d028028eee5c21313c603deb8c672b64c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec22fa1e5722c6299e35db49560ec40d3a7cea88393a50bd97568a9c0900dd0d"
    sha256 cellar: :any_skip_relocation, catalina:       "c987b7c665ffb6a9e63e1eddbd8459103025dd656fc8cfee90e6ecbaf2728c59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea9b6e2fc664b8153425d8312ad395e9a05773f661ce79e794bd0f13dc4059b3"
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
