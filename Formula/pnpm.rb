class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.18.5.tgz"
  sha256 "a2762ea8eb10c05aa3f701478c5a52e298235c142cd6519ca8c0e929c92ebfb1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "86ee92e13433ddaa82e5767ce04f459f095cdfea7ef831beac8e2f2866aa09d2"
    sha256 cellar: :any_skip_relocation, big_sur:       "f1236d4094296957e71c9f51a7052298ddd62066a4d84f51142e41cc7a531bfc"
    sha256 cellar: :any_skip_relocation, catalina:      "a2c0d6ad446cb82be87dd3066627a19011ee1a8c105c18255a9c6a7fc9bacc3f"
    sha256 cellar: :any_skip_relocation, mojave:        "66d05a01588c009e3215ecc78e556c7c7b91cefb9d162520150d9f18e5aecccc"
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
