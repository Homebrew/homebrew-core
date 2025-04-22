class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/docs/getting-started"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "be3d66b5cd0b307d5d1dcdc5c4201660111a271f5f5c45117ad5f3ad1dba3651"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "245ed47d75388c056e9e69e29dfffb2dc9e7f2dafbd0a4218644ba42277c0135"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cb5d1b01af83ccc0916bead928edb350c7c0139c389a91bd118f5b8d662c0e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a53ecdb1a05ffdcb886be9a30cba83ec70e6295b711300ca9188640f71cdf8c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "71d02fd55ca9e22fb22938c9d3263a08dc3d7ef117fd1ff2cd692e3422045763"
    sha256 cellar: :any_skip_relocation, ventura:       "4c290078f35542811364e2ec0f09b3e18d5fdd62e134a4858de868a0dc1da2dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a07fcc4044fecec4858005160c085a94b528c819fc88f8c823a588f79a82884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b645acc8712d35f85f74b1cdf9394d1fc9620f09d3e595d1fcdd95e88f8b8cdb"
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
