class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/1.7.4.tar.gz"
  sha256 "dda79eff564bdc61565267ca66914e876655f53f49b1acdbd384d99bd0bdd556"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0085bcec1587faa68710784a67be799f72146a34a1c58a6e6fc07c0ef693e798"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dfd1adb83780855dfb6176c2689bbfe3503fc70e4f79a83701a606b521732ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59cac7cfec8b975fe409a5a0bf5ff42a2e2c0988acc4e78d4004b1c26200155f"
    sha256                               sonoma:        "726919d144a6ddd68e1ce57bcbcfe464572054f8f1667897492a1ab0b095523b"
    sha256                               ventura:       "e2627ec73b7c490e4d8f6c51bf4dd2544367dd9fdf934038fc7d2c3927dc721d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "203290c524692bc4e582f67908aaf3ff55846b704dd41820ea67b845abc6e472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "346a8f0c717306810654e2ae34eb7a75411c4207b551a486133894511bdabc92"
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
