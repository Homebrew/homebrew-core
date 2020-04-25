require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.11.22.tgz"
  sha256 "e6f09f0693c31bead19c12099235630c48fce03b43facbf5502de501d3343100"

  bottle do
    sha256 "497ee4a0390559e0ea94b4590b10d13ecca3ae801212fcb666f1c42ffa2cf8c7" => :catalina
    sha256 "365cc18aab2923d5a97632c6a4e29306111f6324c9d478af5c4e5573af68d865" => :mojave
    sha256 "1b154e504ea192e8c783c04aa1ecb345fb85e430379239de3266555335c1b599" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
