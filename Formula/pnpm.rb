class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-4.11.5.tgz"
  sha256 "8e2c4c39f46bfb8a6000641afefe6555a94e51adbc884d6c4dde163d581fd7d0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f85ecc1079f4b78490ce96b2212c73a1456bd56f20dae09c11688907bf8cc144" => :catalina
    sha256 "f371795771f8008f34f938e8f189a7c836e757c0bd81014f38e9591a9635df92" => :mojave
    sha256 "2124426d3d39f4afb7c6f62355c980492617e69765bb38bacec101e8f796443c" => :high_sierra
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
