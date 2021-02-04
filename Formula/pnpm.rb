class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.16.1.tgz"
  sha256 "087902adb2ce8f2a36a7d58cc8483fa2e40cb885fcaa40d9ef1df3e72a152482"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "af7cde2aac12ee4eb55dd1c70abcb34e528a042a6402ec8215c0bb589278b91c"
    sha256 cellar: :any_skip_relocation, big_sur:       "38f0857cdfcd85de81608412e85b20ea87ec8b3c55e673b327b36efe34a92f25"
    sha256 cellar: :any_skip_relocation, catalina:      "1edef5556774b4e87c7750aaca79a06d50ca19599be719c2aaa4dcf8f4ece724"
    sha256 cellar: :any_skip_relocation, mojave:        "62e08ef5ce53395848b839f36a5eb921344cd63813619a3adc6289baa1175b05"
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
