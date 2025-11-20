class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/docs/getting-started"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "38b1c8a739a7585eb4aff071bd0e8f067ef35eca6af32acc3a2dec0799a78a83"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54ac1ff6d83c0d456e3f7b977af8d1ede2dee7a3509e807765826d978a7987df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86ed38db72b925e71d8997cab2eba20f53bc98bc7d0d0d63ef754e86df73b72f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88b6aa306ce48e851ebaf6de64d037eb9fb30aa0d327470755d931f577725fc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2f3c717c5e5ef2dc52ce3ceff5d2abae82af15b698e4019b44ecd2df2bf30f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6af3e3a9ce1fe96a070d37ff99500f447691da7a72e1dc4ad2b3a04b8b0d4dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d188beda0f3fa721362700532a835e20d4a6add171d0f13cd7504f4ae15e169"
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
