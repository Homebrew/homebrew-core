class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.0.1.tgz"
  sha256 "6e390217ab6250f85d28cb0135620e3b0526a849dda7fb7c54f092c1b6bd465c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7dd2724314641dc7f644c4e0b3322bcde552e8e6b6dec338677a4dd64a9c02b5"
    sha256 cellar: :any_skip_relocation, big_sur:       "29479f93f68e548a1f53855864fc37292519766e03a064f4bdc32f77ddcdc95c"
    sha256 cellar: :any_skip_relocation, catalina:      "1b7efe5a5540d32a56103f7fdd5de867a24d4be509dcd7719ff7469d2ce0acc9"
    sha256 cellar: :any_skip_relocation, mojave:        "f36db3a9b349ada4fe4ed9cd051d039591dc53e3a04dff8ab1dec3a10462545a"
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
