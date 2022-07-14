class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.20.tar.gz"
  sha256 "b6fe12979334132b35bb8478a236ef7c8684ce7959b1835268e463581d9af490"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5932c36327ef63e80e0b5a7bb6f9984f35e430c0afa392d5da25b68c412963f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3ef2ca02a168c1f5d16f2b9ee5b85e4393cdf034a9ccef2d9277b8d6758b05c"
    sha256 cellar: :any_skip_relocation, monterey:       "468264fd7261e5c3e26a85a6c0bccd2086329ab0d919048bd23be8272ac697d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c9676c6eb41d81fd8e21504f9c6be352e0f3a08acc4a696c3b94ed662a07f9c"
    sha256 cellar: :any_skip_relocation, catalina:       "c106981c6051c4755e5509041b244d40e63f1fa807188b7fc94df350de4e1b71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55f6b250d118fc1359c1069884ee0bb346b569c626d7210000122ca6257c30d2"
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
