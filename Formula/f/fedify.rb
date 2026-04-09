class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/2.1.5.tar.gz"
  sha256 "cae549e59fd0983cca82faf72f7e7722badf6a3f74f04ca352fd825879cc7edd"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0996232da79bc999b846d18e74e4694cbdeeb2b3b61f7cb6eb6dd56a8e28cd58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f0bb0edce7c6901ee08c076345e0cc099ff59af30414f32562940394e96971e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d91f5eaf334ed61c5cf48501eed409df083c5d938cc244fa2a41c2bd41b06f60"
    sha256 cellar: :any_skip_relocation, sonoma:        "16794d66f476d6c3234602a3275155be2b264fc44f614ba234b09069fb9cfafc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca3e1de4f59ab395d62a11ffbc63b7dac76f911d67e795349d373b385401d67f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3df24258a92a2115f1d7ed6d2ddae4df78f68b5a8a9a44863a5f132578b1e72"
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
