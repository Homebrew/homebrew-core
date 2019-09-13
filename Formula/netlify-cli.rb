require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.15.0.tgz"
  sha256 "fdc4f13b32a07870204c3efa05ca7f6e21cab70560b2d3335f265236c76093ef"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 "f42df6af3df79aeaa6361f153d187535c2e0f5d87fa081095d34016408c5deaf" => :mojave
    sha256 "508b2547dc61028bee3ffb33624054992d03bf9fef5f274deb2ba0c291b5709c" => :high_sierra
    sha256 "47a4e5c3d491cdaf1f7a1a534170ea8a48b248da188cdd6a81a7c4a3e6d2732f" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
