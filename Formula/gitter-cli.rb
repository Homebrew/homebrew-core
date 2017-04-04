require "language/node"

class GitterCli < Formula
  desc "Extremely simple Gitter client for terminals"
  homepage "https://github.com/RodrigoEspinosa/gitter-cli"
  url "https://github.com/RodrigoEspinosa/gitter-cli/archive/v0.8.5.tar.gz"
  sha256 "c4e335620fc1be50569f3b7543c28ba2c6121b1c7e6d041464b29a31b3d84c25"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b0c1af334ab94692271f4e88b3f3b44adb8f2e7738cd68cdc20719dbb4f315f" => :sierra
    sha256 "4503b65ec4122d7cb51e8173168dc41dc4e57f978f4246697f9a3bf768f8c9cb" => :el_capitan
    sha256 "d4b1a539db31e5a04e05fc982c6b9961bde7eae94de06d1addc2dc4346f696e9" => :yosemite
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
