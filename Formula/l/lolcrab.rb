class Lolcrab < Formula
  desc "Make your console colorful, with OpenSimplex noise"
  homepage "https://github.com/mazznoer/lolcrab"
  url "https://github.com/mazznoer/lolcrab/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "b318f430e95a64dac1d92bb2a1aee2c2c0010ba74dbc5b26dc3d3dd82673dd37"
  license "MIT"
  head "https://github.com/mazznoer/lolcrab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7735ea58e17ab33fa707c88762e57e78b126f328431536d2be729413be132957"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d410c8c3acea7346c1f07c55c8e0227f6410877e35a32f8a7b8beaff4a9f6b36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3afa507cdc28da20d4a79c9c1454381126858e55e29ff966b5fde41b18c079c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63346783d7d4451971a0445bb81e8c53ba050c7c0790f2f2f6c9b3a182093c7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "23839485ed95006cb6960ccee0c6b4ddb6c932492f76db97faea6512a70514c7"
    sha256 cellar: :any_skip_relocation, ventura:       "63f96e5f06ba3c43dda97dfe713e90428e981d54fc090173dcf2b6b178ffbf71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0970ecc7deade605cac17219372b3d90e9f10cce2814c3a5bb6149e30528ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc1b66f9f87d0c806a6a62aa88e6d91913a6cad76148e13d8938c1fdfc8b7531"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "\e[38;", pipe_output(bin/"lolcrab", "lorem ipsum dolor sit amet")
    assert_match "\e[48;", pipe_output("#{bin}/lolcrab -i", "lorem ipsum dolor sit amet")
  end
end
