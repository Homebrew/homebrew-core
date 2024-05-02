class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.21.3.tar.gz"
  sha256 "09a7451919f6c50be49ba6c9bbdc24586f904c19f9aa2ddb360fed82d16355c6"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee359f05d4f24e186b3ac91c84c25392985e4b8aba96f65c2f190028530a4364"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01f282bea2c2989fed598cdcbf529a8b21fcfc33f992c8628ca7dc43178fe8ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca2cde0a826f81f6671b294ca1aab97a7006bbd4dd68c65bee61a2f0882f161e"
    sha256 cellar: :any_skip_relocation, sonoma:         "043655a8b59d01d4df44777f80fb288752032b9f465b59a1b2d23f02670b8eea"
    sha256 cellar: :any_skip_relocation, ventura:        "f460160d791208264d60e6763a448d30f8ed9b83aff792ae58ae7ddfcf9086a6"
    sha256 cellar: :any_skip_relocation, monterey:       "d19a1896ec41ac659b82dd0a74f679e1d63e6be89eec4a86d9745cbd246181a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8eae2519abcd2fe68e3b1c54816c04175e388aed5d384d26181270f4f6d35af"
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
