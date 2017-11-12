require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-0.11.0.tgz"
  sha256 "2af6a433f43f874ac87e55641fc45228e44ebc9ef0967292813d0e096d4fa4a7"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "5203f2bb3ec825f140741c43802178328bbe1cdac52842d4dfe42891b2c0d10e" => :high_sierra
    sha256 "78dee314349a867117c9ebec759172b4604e9f074df22558205f66f01297c572" => :sierra
    sha256 "b3545bbe297ae46ab0e3a5ed19de52bcd9e16ce9d4d1d1b47e83a17a9dba0d48" => :el_capitan
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
