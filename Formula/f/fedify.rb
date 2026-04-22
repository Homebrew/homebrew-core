class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/2.1.8.tar.gz"
  sha256 "657d0e22d0ebe4ea9800198f58ba1929f60cff082fe44fa20434b0a59fa98f03"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8f782c319d87f23d72a066ee38cdfe56917e73ac8c8b9190f0912e285c5cf49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a53c0db339afbe02709a9ecd3d998239d8fb2f84390bebcbf9c40d3791b88cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df103a49a7fdac409c3e2d11ebf2ba2ddc81896c43d89950e06a8a99f22ce326"
    sha256 cellar: :any_skip_relocation, sonoma:        "135fd72a24f711417b02ce27fb2270ecfac1c879b1aa7fc0abbf1cc7a1a3ef7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66da17f906900fb2a854d076af866d44a0e10c2978863cbbba15093cdd66cb69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "043412dc8bdeefb086868fbaecfdb8071691a58eb8ad0a540dc057305b638cfd"
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
