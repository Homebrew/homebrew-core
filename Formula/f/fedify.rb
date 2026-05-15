class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/2.2.1.tar.gz"
  sha256 "781390d45a15bba814bf9400a4e81150d933f985fe222a59f32b8e6d0f908f84"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8b936c997c92b843815ba140e63b84a3e8c935a6f268feb3e58c65b86b4a2c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9c933e0fc10d52fe614e1218e3fed415ca1a61a1a100a57a37a01298392ad22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efd5d4d87eac7ac0810ab582387093768734d268b2f4e5552b1238b3577148a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f1b981be0efb546790da562e48414d5c60b4625570bdcea525c4eb937f66f0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13c573507b21f8552210f543a1e191c085321b1b0feb13c91345be3c19164034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad5a6635905ea89be44e3308b438d95028000b9236552bc645e92da2483889b6"
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
