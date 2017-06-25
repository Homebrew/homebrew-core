require "language/node"
class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://bitsrc.jfrog.io/bitsrc/bit-brew/stable/bit/0.6.4/bit-0.6.4-brew.tar.gz"
  sha256 "b1f8353381da7ff17ece2f99827d5c832336fbd7bb41ab0dd46a4b233eb4941a"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d7402ed5fdc6c857f14f865bdee62b100930f4187d31ad84a649e88fb62f45a" => :sierra
    sha256 "f4cf14bb7eb79800cde0cdf752130b8de850f17431e43f145b04c5d1437896d8" => :el_capitan
    sha256 "f4cf14bb7eb79800cde0cdf752130b8de850f17431e43f145b04c5d1437896d8" => :yosemite
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/bit"]
    bin.install_symlink Dir["#{libexec}/bin/bit.js"]
    bin.install_symlink "#{libexec}/bin/node" => "bitNode"
  end

  test do
    system bin/"bit", "init", "--skip-update"
  end
end
