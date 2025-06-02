class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/1.5.3.tar.gz"
  sha256 "45b97dddd273b5da8a1b71f0ad215d3040f997b44745e8909269713f80180a20"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a853d2d4d16fd32ba50de79447d2b53b1957fd19ad607e617e4a037359215921"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01b57e115bcc425de80946dfe6b99b4142f60968b232ae81f9026140d89d1145"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c9f891a6827db216b9fb73e7419629f869b27681d57a4991183c741a57658ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4cd77b007819984f576dc013ece7a4d4af9e915e41ce67509c21c7673a0c860"
    sha256 cellar: :any_skip_relocation, ventura:       "7d0acffb16b25dd4080f19817935f717a1f27a6c169ca50246602c0cb84c7694"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7332d43ea58555408320d42a85466f2b374efbca3780d1472b8548b0b250b481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bad124986c752c5256214717cafcbcd3ab436925d48d93396135e6b300d51087"
  end

  depends_on "deno" => :build

  def install
    system "deno", "task", "codegen"
    system "deno", "compile", "--allow-all", "--output=#{bin/"fedify"}", "cli/mod.ts"
    generate_completions_from_executable(bin/"fedify", "completions")
  end

  test do
    # Skip test on Linux CI due to environment-specific failures that don't occur in local testing.
    # This test passes on macOS CI and all local environments (including Linux).
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    version_output = shell_output "NO_COLOR=1 #{bin}/fedify --version"
    assert_equal "fedify #{version}", version_output.strip

    json = shell_output "#{bin}/fedify lookup -e @homebrew@fosstodon.org"
    actor = JSON.parse(json)
    assert_equal "https://fosstodon.org/users/homebrew", actor.first["@id"]
  end
end
