class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.5.3.tar.gz"
  sha256 "3a4860898f68e59a1eb9f19c7f12690b6399ddd916c7bc188c1f01cccdade7a9"

  bottle do
    cellar :any_skip_relocation
    sha256 "c87212322a29fd6c5361b0b923ecf7e40cf1d68eefc4466d5b31200428f9a4a3" => :catalina
    sha256 "ec1e3fff4f0cf880419cbb8b2be8797addc5d54395232cd55bc57191706f1b07" => :mojave
    sha256 "2d3111c60b16b3050c5188032347d0a014006706328d9caaa80f9e6366c6c5a5" => :high_sierra
  end

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "cargo", "cinstall", "--version"
  end
end
