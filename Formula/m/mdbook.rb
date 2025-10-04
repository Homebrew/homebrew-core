class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/refs/tags/v0.4.52.tar.gz"
  sha256 "d46f3b79e210eed383b6966847ea86ec441b6b505e9d9d868294bb9742130c9c"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "765fa309bfd6d5cd4c392e44010330455099afa8c132ed687da1b1dd837300db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d88256249fc2d71b5a7f3f12160392ac79ad8559dd8bc3358ff88be90fafc26f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c99b293bdc9d8b14b8fa694be451101f6d808a87bde842751e4bfaa38c45e0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a356382f6e21900c00511ad40d46222628d46eaea79a7ecb04016b35737d7a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "72dd9db93dce467a951ae9c70c6eb2e53fb577cf16747a43582b6ff5c7f63d5f"
    sha256 cellar: :any_skip_relocation, ventura:       "5b0d7a6f36305edf312aa094d93dc1b565e8a9353cbf3fc60a4af8b09a93117a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4b7323a89d9cee8d61580af5e74b9e9f82235f8fca976ed2a3197e1031bfb77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e17414702ca55f0ac8ebd6decbae57d7460ead65b04abf1bab8b5aad5c667e4a"
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
