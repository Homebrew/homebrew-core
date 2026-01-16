class Carl < Formula
  desc "Calendar for the command-line"
  homepage "https://github.com/b1rger/carl"
  url "https://github.com/b1rger/carl/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "741704427403353f62993687a6d2c5a7452bfbf4c108fd32757522600c4eb2e5"
  license "MIT"
  head "https://github.com/b1rger/carl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7beca609fc53282dc7451f872b8bb92908f1ece042fa5a79e2a05aa99c6a10e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59176df3ef6d8ec8af4ce37f782617d4592d2cd16f763f9fc07f606ff49aa978"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "289a18bc4257358856cf2c3752c063d96446c7c16e3abee45d39db5e0ab4b667"
    sha256 cellar: :any_skip_relocation, sonoma:        "443eb7433ca97631f287ca1b9916a9f71afa8b9e2287575c658c8414721e4188"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18ccfaa0aba8cff9d91e1d5aaf8d876b4324d48915548b65c37b2f5f38a99cbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43a50cd2291193a6d5763989250b18c220e2ff719f71d301174c580c4d2d20ae"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Su Mo Tu We Th Fr Sa", shell_output("#{bin}/carl --sunday")
    assert_match "Mo Tu We Th Fr Sa Su", shell_output("#{bin}/carl --monday")

    output = shell_output("#{bin}/carl --year")
    %w[
      January February March April May June July
      August September October November December
    ].each do |month|
      assert_match month, output
    end
  end
end
