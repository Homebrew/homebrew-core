class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.4.1.2.tar.gz"
  sha256 "e5b1b43203f58130dec0f69b1eb02e7a855cbaa2efcf79274187f9149de016bc"
  head "https://github.com/bootandy/dust.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6343dcf3b0bb0e4a749ae2e7f0145c9e2142c9783dfaf3fdba2ac5b8a1de6ce1" => :catalina
    sha256 "d6a3d605922957c82a631d643d5025511e21e9b0ceddf6b2998b6a0f086c9c77" => :mojave
    sha256 "ae2e22191c5f37c366f6b0b93e0c525a5b2013f32cd0ae287bef84a12490422a" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match /\d+.+?\./, shell_output("#{bin}/dust -n 1")
  end
end
