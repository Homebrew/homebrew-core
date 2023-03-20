class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "f1f93c79690d8d6dd07fe9726861ffcdcf4f990c0eab4a4704d3a1b55b910bff"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efb0d785c48375330dc522b0740717c9f1268dd0a2380670998ae6bf8f909b30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "560edee434263fb569462050702e95b6a49acaf2aeb706948c14f80655350480"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22fde32b54735206313fe791e57f3f622d4af808466141077a81b1e4a39a9681"
    sha256 cellar: :any_skip_relocation, ventura:        "7d89cc96b6e13b4be6ba8fea9b89d3c37c43739984fa42b48f9c8234862eea11"
    sha256 cellar: :any_skip_relocation, monterey:       "7ee476d9f411854f228b6f1bda761de8c77a3233139acdbb55ad530a3325a53c"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf045820b911ff84a051a8e76b1389a76e2fa9af73a293bbe3f12620df7715fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc598ee08cdfa43ca6bb07584473de5dff0653ae7453c71e61da62423e437d08"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end
