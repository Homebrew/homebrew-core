class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/2.0.7.tar.gz"
  sha256 "0d4ef8dd19b003df46b08e9a2675dd1a6e324d156988502d0409348f82d77052"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fe3d14e7c025e445f24035b03bb62c9392c68f5be6f3478c360dea472c16e3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "949222ac864e104e75f1f93d0745f39f16f6a43e6bb3ec4f651da8e3deaf073c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a991fb2e6efd13bf549f0bcaa265191c735f3071077496c9316e9951c7a53ffa"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ba61cf0885822e9718f63343043c174de3ffcc077e2485dd600959551fa28d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe1b13dd96571e4118d13985ff2d79906b13698763268154048030be36ffe098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70badee4adcce3b03e0cce3312e09cedb68fb2ec1b0f960c85f4048e2b54d1f2"
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
