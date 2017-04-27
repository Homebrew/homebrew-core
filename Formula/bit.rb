require "language/node"
class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://bitsrc.jfrog.io/bitsrc/bit-brew/stable/bit/0.5.2/bit-0.5.2-brew.tar.gz"
  sha256 "c6e183684e6f69c729886f96bbb05d39cfad429c92452a48c6c4b421fc1e8be7"

  bottle do
    cellar :any_skip_relocation
    sha256 "9805732d4fdcc054e940d60f330b7b0d25b45ca38d29168e196e31f7d7d3b0ed" => :sierra
    sha256 "63c23872f85bd67d240052fa7a93957ecead787af0fc663286d821c5909a705a" => :el_capitan
    sha256 "63c23872f85bd67d240052fa7a93957ecead787af0fc663286d821c5909a705a" => :yosemite
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/bit"]
    bin.install_symlink Dir["#{libexec}/bin/bit.js"]
    bin.install_symlink "#{libexec}/bin/node" => "bitNode"
  end

  test do
    assert_equal "successfully initialized an empty bit scope.\n",
                 shell_output("#{bin}/bit init --skip-update")
  end
end
