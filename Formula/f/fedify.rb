class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/1.10.3.tar.gz"
  sha256 "95d0f4c9a67e634dbc1778f44e81922b8d5db005bef99e9bdd2b4bc11190c2f2"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5b1f2932ce0753a870ba00637123c45d7041aee202256029db3a8d52809fec6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "693bd4f0f3df137acb695e2600db38af77b83e27dc86af32ec2e255e31907807"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5480d88c068f4329d7c07c53dd55bbd6781f9722990bf0221e25933444be992"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fbc5131edb56f0e1ed8f27609713a91686363e6e125f414838a475fccf16fcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c298f7ef863e09897125235a66214d615c87979447ed381d175229a04cdfd65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8b0838e64c1ac9f49eb1e0e01d2b4ea42e11fc6483933a7d8a1da43ebd19a48"
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
    version_output = shell_output "NO_COLOR=1 #{bin}/fedify --version"
    assert_equal "fedify #{version}", version_output.strip

    json = shell_output "#{bin}/fedify lookup -e @homebrew@fosstodon.org"
    actor = JSON.parse(json)
    assert_equal "https://fosstodon.org/users/homebrew", actor.first["@id"]
  end
end
