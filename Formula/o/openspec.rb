class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.17.0.tgz"
  sha256 "f344f717e50b91d741d734fb15a0cd49c6d3d41471c4b59f22abbd5645c2f253"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2de6624fa0d9c21d947d63195f15fff4e874e877937619d40712c2fc16211202"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2de6624fa0d9c21d947d63195f15fff4e874e877937619d40712c2fc16211202"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2de6624fa0d9c21d947d63195f15fff4e874e877937619d40712c2fc16211202"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "47bb984f608364e6921a6049dda4a0918000f74550f9ef55a4e16d35f92e589b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "47bb984f608364e6921a6049dda4a0918000f74550f9ef55a4e16d35f92e589b"
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
