require "language/node"

class Graphqurl < Formula
  desc "Curl for GraphQL with autocomplete, subscriptions and GraphiQL"
  homepage "https://github.com/hasura/graphqurl"
  url "https://registry.npmjs.org/graphqurl/-/graphqurl-1.0.2.tgz"
  sha256 "1bdac1bb89df5fcfe9950337ec1615ffdaad13fbf01325ffcf2b87d505d67669"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d99d4588ddd340362252448746da5c6cc547edbb7cc9570d5afeeec420e1a0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d99d4588ddd340362252448746da5c6cc547edbb7cc9570d5afeeec420e1a0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d99d4588ddd340362252448746da5c6cc547edbb7cc9570d5afeeec420e1a0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "55b186c4453138065555bb6c4a4b663eb698d373e9c3ccff16a739b7ff273d82"
    sha256 cellar: :any_skip_relocation, ventura:        "55b186c4453138065555bb6c4a4b663eb698d373e9c3ccff16a739b7ff273d82"
    sha256 cellar: :any_skip_relocation, monterey:       "55b186c4453138065555bb6c4a4b663eb698d373e9c3ccff16a739b7ff273d82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d99d4588ddd340362252448746da5c6cc547edbb7cc9570d5afeeec420e1a0b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = Utils.safe_popen_read(bin/"gq", "https://graphqlzero.almansi.me/api",
                                              "--header", "Content-Type: application/json",
                                              "--introspect")
    assert_match "type Query {", output
  end
end
