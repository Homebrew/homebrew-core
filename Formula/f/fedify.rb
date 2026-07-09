class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/2.3.1.tar.gz"
  sha256 "ae68f5b253b3f6dc55c94ab07e090327ce6aecbbb588db31b6605107204ae1ba"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ecb3e7ca223b65249be09047a0416c47cfc4e839a17613d61b883bac3971f94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc6f7e610d5680544056d711c9da64f0bee36b41cd5a98943002dc3629cc82f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "693dd6f8a4c414223cb1322013489666e5c55af62a64fe4a56a9f40fbea4eba5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9639080496b88b044aa69ed2beab9774a6259d06178d180c81f7d9fee0b1ad60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb80ae72747900f088374c28a35169cefc6bc08f05692e8a86417b1327d9c326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4de55e603155ff51fd9ecfbba6fd970f54d284d72096a83142d8e0ecabcb9cea"
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
