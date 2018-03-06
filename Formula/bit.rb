require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-0.12.7.tgz"
  sha256 "b003e589e4f30b277e78104811c9fa8407b6c8688c12b315a1a8f47243b2c346"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "0331eb24d6b02840adb01daa85b42906ba6b44b62a17bb364365e1ba2b4d39bd" => :high_sierra
    sha256 "a03d7bc34f0244b6778b5791eefb642551c39f0d69a323c4a49de5f97edfb84d" => :sierra
    sha256 "2590fbe0aa10a87b0981ff1ad97c1ff1816dfa8c2741f050401560ba95e48818" => :el_capitan
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
