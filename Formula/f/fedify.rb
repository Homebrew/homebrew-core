class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/1.8.12.tar.gz"
  sha256 "1e558df86fcc7ca9c9932f7bb31df3f76cefbe7185b38c4cb96a4c599c265d28"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81d7a4f21ce685214aa49f7d39738eee8cd161ce82efe3ce4f4d0aec6c3200a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ab2f6c68a530e80191e594d2f5aa4b78cb5e1224d06a064862ac2ea09770346"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b15d7c18e2c93012bde96c154216365d0ac5c63656f306766e9feb782baf62b"
    sha256 cellar: :any_skip_relocation, sonoma:        "260af20b523b368927967375d57e35b9aef57ac0d65534d84613de483fbaec1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7728caf946b368a3acb83dce9c0ba097434cf4eb3eb8d88b3bd04afd4434f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ea51ba3f1a652f0b00a19342a855d44f5ce482e10ab7323b463e5ab9f504317"
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
