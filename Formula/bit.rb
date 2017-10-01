require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-0.10.8.tgz"
  sha256 "a8d19cde1ac47937a781a22d2f8ad7a93057a767fa4d68c7218d9f864da729f4"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "8a4d6cc37cb9643c894e9757a230c73f564db45cbb370f4398f9626f61288bb1" => :high_sierra
    sha256 "73cc43639f43ec9d2bff4df27240d8b2da7d3adc8e8cf0a342ad3403eb1b66d0" => :sierra
    sha256 "a8c1584a2f45de3fea269a3c52c1ebc715936dd7d83e81671471325351bec60b" => :el_capitan
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
