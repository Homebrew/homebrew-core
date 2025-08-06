class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/1.8.1.tar.gz"
  sha256 "6e6423ca693e8cb0dee6670c49932ae519f01b9f70931c9b786a896342441c58"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bceac01dbad22a64f1b8ac8ef611ee08c500bd54a3bc9a35fb6a62242f1a3a73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adabb976d0fe2029526ed4a789bad21716e347e489e518e56819560b548742dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e62858858e69610426575b38d9ea7c4f55ba45a4e35d8e05a805bbf1a7d33499"
    sha256                               sonoma:        "c1b644b7bbfa2cdf0ae5545a49750654424fc58f3d81faaae927527fee1ab925"
    sha256                               ventura:       "c273110304348a73ee8ef5fa3606ff138e20efcac8a37d8f5ec067889c1c20b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2065c1414acb605cd5a494350d324e42fee0ef82fc778ccd8bad50701ed6ca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "267a44b36a709922167302235cd16b6c1a6f445335db214822fc4e1132d550d3"
  end

  depends_on "deno" => :build

  def install
    system "deno", "task", "codegen"
    system "deno", "compile", "--allow-all", "--output=#{bin/"fedify"}", "cli/mod.ts"
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
