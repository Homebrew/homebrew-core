class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.6.2.tar.gz"
  sha256 "4ab5d8200368fb6ecf185a1c896f51fb96f94e3ef853d258b128b8303c252300"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "af8b361a8542078345b1d9e8b711fa61b3055c481b13eb73b5bf1c19055aee94"
    sha256 cellar: :any_skip_relocation, big_sur:       "a4f9bfc53e06294ad7fc5b20ac91cb058ef3896af6227c1ebe40783d56e976a6"
    sha256 cellar: :any_skip_relocation, catalina:      "100a00e7bb6e221e039238221784206d599956aa455a02f32517b2e16f868598"
    sha256 cellar: :any_skip_relocation, mojave:        "56ed4c3d53db4a7dcf6a392fb4a5158e10dd97936eefd629b2d0638815205b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93800380649110cf57ebf3c93bbd0598e0ea5b47fb9a9903a990c61a842cd363"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match(/\d+.+?\./, shell_output("#{bin}/dust -n 1"))
  end
end
