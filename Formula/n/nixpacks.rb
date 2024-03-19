class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.21.2.tar.gz"
  sha256 "b1cd2320080d9fbf3acd777b6a1a6e104dd62cc08091e1b98355feedfda1a703"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "590eb20c825baf3b751d8eeaef93eec9be63f77eda5c5ce7a839b662165e4ac3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2682e2a37756a3e718f8f240643b9c0f0a7b3fdef6fa604570a9418dfa64652"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c43a9ba1697a223f1b632bdcbae30866b7686439f38e63d70f659742ee7f9587"
    sha256 cellar: :any_skip_relocation, sonoma:         "25e2c883ff5529501680560d62c885ae46e18b87b5f4d68cfdf337a51e72afe3"
    sha256 cellar: :any_skip_relocation, ventura:        "7e618c3a599f403edce1355ec148292deb425180e0ae6ac35bd8206dd9163153"
    sha256 cellar: :any_skip_relocation, monterey:       "f7b9c4d72a71afd12d451f08940453b85553638f7e94e11e2cdd6ca3fe781481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd7a37eb44e7f410733c5642c500ed90ce09d07359c3c05c1b71de8e92d32ba7"
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
