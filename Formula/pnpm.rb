class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.14.1.tgz"
  sha256 "4ed17ac4706ed9f7818d40cb893d0c3a8b07927f1628ef9e15ff8fb689be27b0"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bc604bb872545e8e2448989f05c6d3afcaa25408a68cfa946ffafe698c1faedb" => :big_sur
    sha256 "98ed94d512a13af20ae2ed3236ce7250ac3f336ccc55b77eda7589ebf5af02c6" => :catalina
    sha256 "1d70cb1c63cc69cbad0934f6c7c96e3d479d65cbddfe3d1dd3acb9dea9915d8b" => :mojave
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
