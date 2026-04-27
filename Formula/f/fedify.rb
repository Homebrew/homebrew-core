class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/2.1.10.tar.gz"
  sha256 "3f22201f5ef1c44f9af9f8368a9e2768aa46ea8e7a0e264055d8c6a08f583201"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6b79974db9e483b818b91d580efaeccd664aa1fd987ea8be2638681af705d1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c213d89b738c9906ac89155c52570da9d4bb8f56d6823d0d7aa97e23133f46c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47daefd4899b660f821e6dc4bb0d93327bc510fb1d7a6f08d794986eab9f3c1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "62b148dd033f7c470abbefc51bbc0473cf00e176f5227c601a6c0541feda4274"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a2064d365d86fb01b8ca593fed0d56113c0661d4ade99c9e72abeffe9d2d3b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b60309f182fbed415d821d0ee801ea1691275b18bc27c937d220275f2d5e95f"
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
