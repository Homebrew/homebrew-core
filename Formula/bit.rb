require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-0.12.2.tgz"
  sha256 "06de06ff19791a75c6fc93e6ac60166e7c837203109b447bcd19ddce078f93f4"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "9b9e56f3892b0c5f873bb012dc057cfa36ae100e5b0c7bbcf6daf1f0abe4e886" => :high_sierra
    sha256 "5c977e436375ab9ef65a35bdf428f44c41d294dc49a1f8c40bd3d521ba6be05e" => :sierra
    sha256 "0582eed01b9b1ac182c08431169f445bf893ea1d600dff6b31ca9a3765ba20d3" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "successfully initialized an empty bit scope.\n",
                 shell_output("#{bin}/bit init --skip-update")
  end
end
