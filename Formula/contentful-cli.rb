require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.52.tgz"
  sha256 "94edbb51ab38deb1b74753bd53f4bb28ef96094876f24132e1034c5163e7cbce"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6d14a0b4dd60f1fb527b37c5af97e065a50156e49bcced5df1cc8eb41040c70d" => :catalina
    sha256 "cb972093b7887aac99f23c904e9c1161433ed105f1b25b93fef19882aa112a3d" => :mojave
    sha256 "9519bee862e0b66979cbdab4934e2d9b4e343d5f20d7fb8a585edf44872ce2a9" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
