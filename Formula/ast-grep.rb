class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.6.7.tar.gz"
  sha256 "4ab3d9fd522ae20b474b355f7b5e0edce011a904bca3a91f81fd7b4b1d125329"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff2d437f2bf9b1aa1070e8276b9ec1b1ab0fb462904d806fbc06ccdbc80c735f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bb2a255fa3e6596268c4c455f7f238934553731324495b657d5ff0b1d344282"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "047de56bf9011cfd80ba85fc84b7fe0975d789eccdd6892833e767fcd82f0a60"
    sha256 cellar: :any_skip_relocation, ventura:        "801f7bc4afa95115faf86b0ff24ef643cecfb5fac35ce6610df35723fb80ba08"
    sha256 cellar: :any_skip_relocation, monterey:       "37b9f60cc007fff8a343ea3fa340d38b9b444cf078849ba82dbb7472aaeb17c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "1da55142648c631ba95f98cc04563bf7b231d555169b8ea2a0785534ff8b264a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5afd376826469b5f0f3156bce29da5eee9ad3d37a970f84f79a4061f973c8793"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"Hello.js").write("console.log('123')")
    system "#{bin}/sg", "run", "-p console.log", (testpath/"Hello.js")
  end
end
