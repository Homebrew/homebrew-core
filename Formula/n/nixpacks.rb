class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "87f4589f0fc79f0035b993f3a8d01b63216e24b526f0a00a677c8607e8ba342f"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42dc1d0a9fc119a543854845762b2c37fdcd4fd871bbbab5a7a2031dd9bdbfb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5499786fdc884da9402e8b1a544b637b640957e63fc71d74294584cc80d2b11e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "afd17ac18b50da2d358c0b3a035862e41bee0c0507984e5b15ff754338592ef7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0eed4d6b82de58a7b348e18490cb105ad47718a6d3968ed741d55b8fa6efb60"
    sha256 cellar: :any_skip_relocation, ventura:       "6ed56913ba2ee5cdfe03902f85d232a63946b89ca597e8f098a20ea46881732a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f37cfc472fa48b5611923f01371bf871e874b97a3c811d9f0f76c620d2a7708"
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
