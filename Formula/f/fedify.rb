class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/2.3.2.tar.gz"
  sha256 "d17e0491d234fc8f2adf95068d242d0f802c9a4502bdf27b1dc79cc2f1052bec"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d9e0c4c3fdd7ae77faf592b9138e46e6509ccd6b4e95da6b2bd647be94ba989"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e91c1ab7ffd001dd22296092d1e7d58c3c8c1f4e3cc73d0ebb4f2c2378ddcdaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a95c9e28170220abf565c8428c7bc7de27cfd2da2f444cb730421f12d908c998"
    sha256 cellar: :any_skip_relocation, sonoma:        "233600bb3f5e1d5f3613711da6bc2c25bcd7254693d7c13cb1dca8d9cf173a1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8389885434e2b98395b109c7c9f52b52aaf7c4079cdb1d86dc85e5a0084523b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0310c79cee4e6458402b4b4010d90e86c0e53eaf35f2af561bae84a2d73c2362"
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
