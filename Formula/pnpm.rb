class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.9.2.tgz"
  sha256 "8996c56a479eebac3384955f87828ce4a38a26c4fd9f5c725f94840fac15c320"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "221a48b3c74e9db179adcc087e6e9eb7ccc3219cb8b2477dbe70500c7b80b96c" => :catalina
    sha256 "3661f9749a00075ea58aa7be20947f511fe5a8e2a2a81d354b06c95417edaa1f" => :mojave
    sha256 "9c05e3937ce9da84744ad3d31cfb17c62c3962dcbd8b272c8027bd78539c5dbe" => :high_sierra
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
