class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/2.3.3.tar.gz"
  sha256 "0c2c79024e2e9a7ab92655d94204dc282cea259d017fbf532cce02da4b130a63"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "408ef4ee08c6dcc5f22ba4d3d584beed448491cd43b2c2fd60541264b7ee56ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "581ba14827d9b12e7866905d99803c9fe3d74636dc1746cdf8ee0385425cd4c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91109d437ad68bcd2401eb04826f56e54d7fb3c01f69d23850977a75ade7b68b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d06cbe705a9ca3c02407d6fa287622d177604a6348b2f71ba4a9dd9a98f32ed0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e590cb138439a6ad173557c1dbda7c5aa1fb1ee4a3d028ac72d9671d734b1cd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73a83e86ec5cab23f258c559d2a5f2facb95f4dff0f6eb4b84f8c705d5d536d8"
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
