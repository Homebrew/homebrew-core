require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.0.7.tgz"
  sha256 "46f6bc79195c0026739b98a91084345cee1caac71edcd435f1ab97ecdf8a71bb"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "edf045afd34ef67e95f937a31e3c7305248b0ea89cb045ab3e5d5fe0497817d1" => :big_sur
    sha256 "8e6dd36271fc4be970ee2f584539984dcd41d02d80f2f9881a0e876cac31626a" => :arm64_big_sur
    sha256 "ddc2d60676b8fe90d939f4e7969daf548786355db0cf273e111d399b0ae25bf8" => :catalina
    sha256 "20d8b1b1c9c121e82355dd9f3adc37fac31824c216a6a3588128b002fb37159e" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
