require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.6.11.tgz"
  sha256 "c11b0778c1885bad0193e7791190ded04610875029c5114db08387ff7461d304"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f90c515090895c2d0aa87b599b0438d5d94b046bab6787eee6ef202b42f6951" => :mojave
    sha256 "58f7ba50912c946be175d8e994d0b51c693fa2c18adac30e6f157874a01742b7" => :high_sierra
    sha256 "be6727210ac11fe5fbce1a9696253dd13351d00b2e8a6a75ea4e61a6d130dbfd" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"nativefier", "--version"
  end
end
