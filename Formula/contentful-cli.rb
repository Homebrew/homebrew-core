require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.1.1.tgz"
  sha256 "66e6b100ffacbd9a1d089ad9765797949756423118237eecd0337d142a8baedb"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "887cf83d6ae5b96f6bd2844a2c0f18bb6ef9db8ba6baf7b2917f6ed2055089ba" => :catalina
    sha256 "9ac2f894be87000b3d095ce37c132655d480963a607d1d615093b238d19e36d8" => :mojave
    sha256 "18eed5d30e93a18a23335aca312d62510e1e5d7b6a21435f862fc73b0248bba2" => :high_sierra
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
    assert_match "Or provide a managementToken via --management-Token argument", output
  end
end
