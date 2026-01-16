class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/1.10.0.tar.gz"
  sha256 "2a567341bebf90a27ad9e2e15774538da0bb2734444c05545e4ae62f009093d8"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b7179e7af4e4a58b670810c178dc3411c482185f64f48debeb53945aad54ebb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebf72d9cbfd76b2ed7e117a72af7b05a710f9f890c8b60f99a2d0008d6fb2b39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cd59514c90521138b6e99d9ba15c9ddfefcc4a3ce4ce1c4ad40276e9fc5bbf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a998198482565a62908cde5e5b4653fc77e975a0528709ece66c4f66a5629bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3fcb69cdcbc7b093ab73925b4dd2cc0abbaa32b89be722f044bb2893c692362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8df44de056aacd5393f27325fa2361e058348d8e37e0f511c438775288ee965"
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
