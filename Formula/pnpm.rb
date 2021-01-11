class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.15.0.tgz"
  sha256 "1e49e589667230171975de73fcac9ac9b5d869dc8f31829711b500f4014ebd6a"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7ad15e088f7c1c3002eb019f8bd565639dd13e0a21db279ea083109ea78f5bfe" => :big_sur
    sha256 "ebd1c5a17e63b2ba3be01513b96aa57a85b236f2cde86ac2b781234c07a3c1d5" => :arm64_big_sur
    sha256 "dc69643947d74bef478404ae1ac2f0a429418fad05f53d4e635c3eb9f62dbe39" => :catalina
    sha256 "4e41b149cb110be282af9dc86d9323c3336ffaf3e2bc16261a9ee1329e02136b" => :mojave
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
