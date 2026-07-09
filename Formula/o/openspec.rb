class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.5.0.tgz"
  sha256 "9e0c3c1b88ed3e8de9e976916104ca4f3cc8b17aded4a61d8d25595c58b1b8e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdaec74740b4883dacadce5572ff5862fd155b580db3929818af270d80a9b6a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdaec74740b4883dacadce5572ff5862fd155b580db3929818af270d80a9b6a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdaec74740b4883dacadce5572ff5862fd155b580db3929818af270d80a9b6a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "13b418a39e17d3c8797b4c565b2b507f3db7b6d5b0ccd4c0e4e37341ff713a21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13b418a39e17d3c8797b4c565b2b507f3db7b6d5b0ccd4c0e4e37341ff713a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13b418a39e17d3c8797b4c565b2b507f3db7b6d5b0ccd4c0e4e37341ff713a21"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    generate_completions_from_executable(bin/"openspec", "completion", "generate")
  end

  test do
    system bin/"openspec", "init", "--tools", "none"
    assert_path_exists testpath/"openspec/changes"
    assert_path_exists testpath/"openspec/specs"
  end
end
