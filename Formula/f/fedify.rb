class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/1.8.11.tar.gz"
  sha256 "9a2e6fdc8ab549c118c3bd7251239de46f9328c923598cb3dbba13c3a61e81d1"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eebcbdd3cfa8ea45d289ae78ef2c0a62335089d6f9d32007b2611a5662f43ac5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37b374a34205e20e6de1e63493cc72e9b7083f9e86e224ac96abf06b5728fd62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9153f1dd8c344496264ddfe52c9ee124ac7a475970d314432aba891a38b96e86"
    sha256 cellar: :any_skip_relocation, sonoma:        "31ad44492052ef045b6af2184c88d0063ae933ad551fc529aaa6c4018528aefb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e043f5bd75ba6d0b82447b0c386aee1e8c6c2c472cc6433c52ea1195c2b32bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f444d90b722bf5a2ed492bae314495773770562edb65898285bde1840155b3d"
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
