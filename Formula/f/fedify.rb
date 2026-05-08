class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/2.2.0.tar.gz"
  sha256 "e1416a79cb3b6c0186336ebea20ee0d562c27f1072cfb5e9332055d719f20aa9"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e0ea56f62639e7549976cd4c296ee88d252dfbe617f18f016b403e3f63865ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a54426a76dd88e6e266ed1cbe8b94a2fff843b44a8bd140cb17f5f8b6e046de0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89129027aeafaddc9d244465bf4f1f6c1f727387a217945565f42074a20d9678"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c610c208d3b1e80ee541fa4bd7122096f4aca611a7969de51a619fb3cd827ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9a870b2b2dac17e3615cad22e164d21cb587e0ff456a807876d8cae3f58ae67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "482746a5bcbf85c48e55b2588b4828ba41fba8494362c684d103dbc009e7eaa2"
  end

  depends_on "deno" => :build

  on_linux do
    # We use a workaround to prevent modification of the `fedify` binary
    # but this means brew cannot rewrite paths for non-default prefix
    pour_bottle? only_if: :default_prefix
  end

  def install
    system "deno", "task", "codegen"
    system "deno", "compile", "--allow-all", "--output=#{bin/"fedify"}", "packages/cli/src/mod.ts"
    generate_completions_from_executable(bin/"fedify", "completions")

    # FIXME: patchelf corrupts the ELF binary as Deno needs to find a magic
    # trailer string `d3n0l4nd` at a specific location. This workaround should
    # be made into a brew DSL to skip running patchelf.
    if OS.linux? && build.bottle?
      prefix.install bin/"fedify"
      Utils::Gzip.compress(prefix/"fedify")
    end
  end

  def post_install
    if (prefix/"fedify.gz").exist?
      system "gunzip", prefix/"fedify.gz"
      bin.install prefix/"fedify"
      (bin/"fedify").chmod 0755
    end
  end

  test do
    assert_match version.to_s, shell_output("NO_COLOR=1 #{bin}/fedify --version")

    json = shell_output "#{bin}/fedify lookup -e @homebrew@fosstodon.org"
    actor = JSON.parse(json)
    assert_equal "https://fosstodon.org/users/homebrew", actor.first["@id"]
  end
end
