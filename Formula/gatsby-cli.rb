require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.9.0.tgz"
  sha256 "85afc01c772855e7beec4b8fa9409cf0b9ac9689b26ed09c60fe1d2132da0999"

  bottle do
    cellar :any_skip_relocation
    sha256 "93108093ed2f6f126bccea11519681dbb53781f0257a9e956ebd06b84e3e4013" => :catalina
    sha256 "a4104803841579af9277f2e106ffda644c35ae061f45f4e9c4c8e7fbabd55abd" => :mojave
    sha256 "f71999f4df1c9907abd1a26a12d83f50f602cf7057568d6810544010ac18cb45" => :high_sierra
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
