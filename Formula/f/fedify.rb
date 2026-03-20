class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/2.0.6.tar.gz"
  sha256 "d3ca5069e23e360c5d511a43927d377aff975c6e53be6a163d8295983b8797fa"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b78af529fc6b99b7769e5fb234fd27f656001b7190bb1f6d927df75422565802"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eee2f7b840f2b0a90105c1c6b096cb1c442172541e6b7a2c588cef4c33f7f0f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a810ee45ad64ac9bb33a4c117179c69f79cdc35bce35839e5472463d9edcf652"
    sha256 cellar: :any_skip_relocation, sonoma:        "27c3b4c8ad89156a0a6ad51f0373cad4bf36705e2588f40fe065fe21fa72130b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "345be038c690dd867c672de2ce21f32c732c741ac5de013792e0f493e6c5512d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efdddb83d4e4e863b8438192310fa1c73eed918d476ad4f17e7d0f5a9423e4a9"
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
