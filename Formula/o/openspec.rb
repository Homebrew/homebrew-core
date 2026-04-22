class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.3.0.tgz"
  sha256 "7e0245e638db3b494aa5e4c49c359688fe6a0cabe7dbe2d6c28fd730582e8e6e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac43475d5e095f0414df462d4349b50316b6fa8f10976e5cfe2e70f60b3ebc57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac43475d5e095f0414df462d4349b50316b6fa8f10976e5cfe2e70f60b3ebc57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac43475d5e095f0414df462d4349b50316b6fa8f10976e5cfe2e70f60b3ebc57"
    sha256 cellar: :any_skip_relocation, sonoma:        "0db00bfea938c6d2bb515abbce5cda45e055f66c2588a6833cad6fd85a62d4e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0db00bfea938c6d2bb515abbce5cda45e055f66c2588a6833cad6fd85a62d4e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0db00bfea938c6d2bb515abbce5cda45e055f66c2588a6833cad6fd85a62d4e7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"openspec", "init", "--tools", "none"
    assert_path_exists testpath/"openspec/changes"
    assert_path_exists testpath/"openspec/specs"
  end
end
