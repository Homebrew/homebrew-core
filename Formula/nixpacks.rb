class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "aade941bbe17ab25c4d2e767f2e4a50faa0e0ede5d4165fd79023b5578c6b7cc"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f126c1d0a3c9d0d0f202ae0246e840288aaa9334aa0d7674d5c12e3ee483fb17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86fe51f07f701427ab97d3d25d894c58d025e56aff1f7876ba61604c25d23ef6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ef5c9f427caa73b86f02a9ff1cbb2505f682bed726ff17cfeac5b5ba117d82a"
    sha256 cellar: :any_skip_relocation, ventura:        "5a83fa4184d0661e2ab596cc893001dd3587170cc4cc7ded6efcc5bcf642970e"
    sha256 cellar: :any_skip_relocation, monterey:       "ed1137ed2c52ccd6b67a1ffbbe2512e5c85f6af6e0b3f236e764b98e9978cd22"
    sha256 cellar: :any_skip_relocation, big_sur:        "52b221c78ddfb4e599f54bc91cc227f1dcf92134067072ec78929b23c0285d7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e739bc03e701ceade70b6ad8f143a917a82653e01466aec03b049d1446368aa2"
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
