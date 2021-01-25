class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.15.3.tgz"
  sha256 "c2cfacd98e73838fb487cbf8e38b1fd8f8c01015bdb4e65557192ea57ca0137f"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "93887acaa5d642ea0b0c34bb752c606a44385f7e8989b73a592c56001ef59c95" => :big_sur
    sha256 "9657cde1496303b330afdf9104541ae3705213af86a9f3aa08a13e527e1e31e2" => :arm64_big_sur
    sha256 "19196fbe14a83359e98d55bb89cbdf4951d77b8f85e0c90ec2a88460c5691ba5" => :catalina
    sha256 "9a0820b1128b86b7333ed3e8a47116332a7b809609d52bd64cc6d6d666aa2bc3" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
