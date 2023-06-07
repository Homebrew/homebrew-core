class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "b10ff6242f6500eefe212ceb13ea686d770457d942ac0514a147bcfcfcd0259b"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d05d147ad1ec96baca3385308fb500f2b89f56c1d750bfa20a62a9a1db2b753d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "991681aae1195dc96bd7b4f7fb547280dcd30a112a3eb9aed2bda047ab1a7cc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a166e02a13f1fb75de85201f135ce8073736f75c7d67b674a6a9ed07d9b3d648"
    sha256 cellar: :any_skip_relocation, ventura:        "012cd83cc0327afa4ffece13c4d50498883d13bd87f6fb8257296c2e70aaac67"
    sha256 cellar: :any_skip_relocation, monterey:       "d901c509d4a604cb8f654c7075d08c6afedddce17ff462fd374468d6606ad5f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a39c5c732297f287c9f9848f9e592a717cdfdcd36208a635b6fc428e32aa3970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "421ca79ae62ba147e8da7074660f9e0a354531315e547858dab06b92e12d7eb8"
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
