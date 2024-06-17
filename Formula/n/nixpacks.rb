class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "346d33abd8141c15c4115aec0123122af5f00c3eb827e83e6ea261656db6e21b"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "509840872ee9df63f91acdd149ac299f66dd7390e65adc9b8b9575a03fe72838"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb35942195ec4277960c5711d8850ab1f1f20e1978e99c1ac5271a34cf252656"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "725fb9b7efc3e1df1a70ddb77c8ec066886f83af7f59377bef51cad4bfefa319"
    sha256 cellar: :any_skip_relocation, sonoma:         "3724c28f69389a97b621481991bdb0845594e104d66e2019811190ada52db58d"
    sha256 cellar: :any_skip_relocation, ventura:        "1e8c6a684bae4b34ac1d21b19247e9c4c6b8d048210641d36ee73abaaa842a94"
    sha256 cellar: :any_skip_relocation, monterey:       "3326510646db7747189fb3ecc4efab5b1020bb589a2e9fc38e94c46e099af081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b27df884c86b3ba35a179dda3ce8cedd2c6fe8f819f928c2cc347cc7e812abc"
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
