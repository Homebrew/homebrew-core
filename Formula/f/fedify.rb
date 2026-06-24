class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/2.3.0.tar.gz"
  sha256 "8abaa41724b451e324ba497f43c624fd5ff0be76f943f148029fe3ae3424f004"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "123f67f7934b3541b87b4353b5a200e0f2c50bf102e9fb3aa5ec1dd2dafe8b9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9e1b3da532193d57bce79dd6947af0abe43a1de5e018976d99a97753a597c4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8810b75c800451e1cf75b206d74ae2b58ca700c2eae538137debc6089f47133a"
    sha256 cellar: :any_skip_relocation, sonoma:        "708ba5559a103040e881c96e81d0ccd9109d609965c58c5f4d0a7f6c53c84c88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d469619898f78cce86d27ee8c0a9879f75168a867b123d86adbcda5bcb7dd4f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9bb25e68d1be79317ee4333bc2ab054d397c563fdf697d01ce406580b423aeb"
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
