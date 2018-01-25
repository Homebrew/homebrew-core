require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-0.12.2.tgz"
  sha256 "06de06ff19791a75c6fc93e6ac60166e7c837203109b447bcd19ddce078f93f4"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "21f558ff32d7242467b586bbd51387aee523079f123bd7c9e24a4ce9ed65193c" => :high_sierra
    sha256 "04475ee492ecbfaa3931f7e5bb4e43b4dd2b46b591855f172c0b9800f8e4c88a" => :sierra
    sha256 "61436028c4a2078430540dae99de468c5a2cdc72972909d53e56398fda365bc4" => :el_capitan
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
