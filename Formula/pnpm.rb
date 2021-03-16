class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.18.7.tgz"
  sha256 "741cce51cca821ddb11d76093641a5dc727299e3eb81fd367ad84d8dc7154da0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "58e7435fb1147da7fc6129939f07df8893cf1f31bec68d7a3888052a1fe5f90a"
    sha256 cellar: :any_skip_relocation, big_sur:       "b3e4a2e10726ec11f66ed6d1f1e735af50a5fb5cb66f4022ea8ab2ec3cf02037"
    sha256 cellar: :any_skip_relocation, catalina:      "e2e3ff4022d0b7996d5643d1cec1a434072f6603ca250d53cddf1cfa55d0f9df"
    sha256 cellar: :any_skip_relocation, mojave:        "bbee681124c88639a82af189f21e779f46ee806af3d835de7015529d0a27c6c7"
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
