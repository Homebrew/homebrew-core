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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ba89a8ce4968565f44b159fd38dca9491f95bb1f8fcd9a39d19fb67a75b9bb76"
    sha256 cellar: :any_skip_relocation, big_sur:       "6f84112c0ad67a6f3098d672e01529d26be71df0ab6bbe60c8becafa8f8d9d81"
    sha256 cellar: :any_skip_relocation, catalina:      "6d025629e4db12253d716caa7c4a26b7a4dd575cd14474846fa71f506ad6f24c"
    sha256 cellar: :any_skip_relocation, mojave:        "19f98e79ccaccda3d58483fbc59c345b3833b62d61254b663ad28f4e56cf2bf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8686d1ba2941e40dc66fad27fc7ee97a1cb2474a6becd94e35d81f3fc88a1a7b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match(/\d+.+?\./, shell_output("#{bin}/dust -n 1"))
  end
end
