require "language/node"

class GitterCli < Formula
  desc "Extremely simple Gitter client for terminals"
  homepage "https://github.com/RodrigoEspinosa/gitter-cli"
  url "https://github.com/RodrigoEspinosa/gitter-cli/archive/v0.8.5.tar.gz"
  sha256 "c4e335620fc1be50569f3b7543c28ba2c6121b1c7e6d041464b29a31b3d84c25"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ded7d2d1699591044372318358e80ddded859348b17be44bbe8692c886ab286"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8333cdaf2d1896ef53257664f5fe6433433772632c19e0fc3aa4784714ba308c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db56401085f8c41a3892d4fed62af37b1a0b02bb435956a2ecc7b385c6d77ec7"
    sha256 cellar: :any_skip_relocation, ventura:        "9707225895e3e3f8323ee1e4e504f3a93c2ee891c6a30bfa72e3dfb4015f145e"
    sha256 cellar: :any_skip_relocation, monterey:       "ac8a05d52db25a2cc9fa56988285e33d890802e5372c815ff7d5603c744e0279"
    sha256 cellar: :any_skip_relocation, big_sur:        "e35dc802e3dad7ce033c0489dc5939872715660c7dbdd812c84d3abe0a5a7f8d"
    sha256 cellar: :any_skip_relocation, catalina:       "b65d3049c2aeb35b63aeece9d9a08f224ec9e4b3aa2d64c1d8a7850ea631f836"
    sha256 cellar: :any_skip_relocation, mojave:         "07256d350f14363a87f7bcf2457bd963f3dbe8f87cbb988319319340b02911d4"
    sha256 cellar: :any_skip_relocation, high_sierra:    "8a9a8bea2541bd954d589f4195665c8f2a36090fba16a6b652f88337a029c117"
    sha256 cellar: :any_skip_relocation, sierra:         "6b0c1af334ab94692271f4e88b3f3b44adb8f2e7738cd68cdc20719dbb4f315f"
    sha256 cellar: :any_skip_relocation, el_capitan:     "4503b65ec4122d7cb51e8173168dc41dc4e57f978f4246697f9a3bf768f8c9cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "313ac86a0ec749fb863bce7e6f3aa789d4172cb04b294361508258053bf66af9"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink libexec/"bin/gitter-cli"
  end

  test do
    assert_match "access token", pipe_output("#{bin}/gitter-cli authorize")
  end
end
