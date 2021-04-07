class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.0.1.tgz"
  sha256 "6e390217ab6250f85d28cb0135620e3b0526a849dda7fb7c54f092c1b6bd465c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6e6e277236386644eb7a1f452d21b607cbf3ea19f6c0bbbfcb2f835d142c69a9"
    sha256 cellar: :any_skip_relocation, big_sur:       "5ea8f45b508c099924f4009b5c3457d27ac9e8ab30b1c4630169ebff38bce6b7"
    sha256 cellar: :any_skip_relocation, catalina:      "5fa766c92f4dadc95ec6214305f21da5fb6bd17e1b19a852fe875bec2d154a04"
    sha256 cellar: :any_skip_relocation, mojave:        "72dee32a276abfe2b295b64490c9dcc2e6c5267574fbb5a5d3e6fdf2764d9a6c"
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
