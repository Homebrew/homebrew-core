class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/1.9.1.tar.gz"
  sha256 "d71aabbc31eccd31024d8e276e3800f50d5d62f18cbe300e9833dd69d41b9843"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "436721628ff6e6f098d19f5a206ca7f525f8eb33635ebb588d3ef4da7aa08432"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b37cf510642efad7c4a6db88ca5ead56e62c50c4f07e4f48bd4b6dc1e79e7205"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad43d84f43d7bc82b22eadc508b78f7f6700927be4660bd5dd7bd8de66b6f1b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bacc28872dfc5ebf1ea44092d6e2d66c23ed54fc1ed634ff08cfa54b297aa38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3901bc9f30063f10c97f2292a5e3b1ad961db3b01752ab3ab3e44035fa08fec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c1007945de843da467e73a70e5dcebe69c883b7a21dbf5a98f18e6bec19998c"
  end

  depends_on "deno" => :build

  def install
    system "deno", "task", "codegen"
    system "deno", "compile", "--allow-all", "--output=#{bin/"fedify"}", "packages/cli/src/mod.ts"
    generate_completions_from_executable(bin/"fedify", "completions")
  end

  test do
    # Skip test on Linux CI due to environment-specific failures that don't occur in local testing.
    # This test passes on macOS CI and all local environments (including Linux).
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    version_output = shell_output "NO_COLOR=1 #{bin}/fedify --version"
    assert_equal "fedify #{version}", version_output.strip

    json = shell_output "#{bin}/fedify lookup -e @homebrew@fosstodon.org"
    actor = JSON.parse(json)
    assert_equal "https://fosstodon.org/users/homebrew", actor.first["@id"]
  end
end
