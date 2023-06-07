require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-50.1.1.tgz"
  sha256 "11587e877bad9a6859bb14268d56a60548d44e550f0d5da6d8535d9051957207"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7ef04113db1fdd60343c43e57add0e37700c11054f0e3c77c0b3ee5bbf7d970"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7ef04113db1fdd60343c43e57add0e37700c11054f0e3c77c0b3ee5bbf7d970"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7ef04113db1fdd60343c43e57add0e37700c11054f0e3c77c0b3ee5bbf7d970"
    sha256 cellar: :any_skip_relocation, ventura:        "25fdd3946dac8e03e6500bb749666c4e63ce20e5a1a30fdf13bd9d1ed3c0011f"
    sha256 cellar: :any_skip_relocation, monterey:       "25fdd3946dac8e03e6500bb749666c4e63ce20e5a1a30fdf13bd9d1ed3c0011f"
    sha256 cellar: :any_skip_relocation, big_sur:        "25fdd3946dac8e03e6500bb749666c4e63ce20e5a1a30fdf13bd9d1ed3c0011f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7ef04113db1fdd60343c43e57add0e37700c11054f0e3c77c0b3ee5bbf7d970"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
