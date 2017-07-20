require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.12.11.tgz"
  sha256 "5420fae717c175de3acba2f1e444af799a2e587efe16e4aab7c351ce6264bbc3"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "da9ac37405f5aa07887fc039b4632157c525f0826e985a9fdf8be88fbdafa657" => :sierra
    sha256 "ff42e4e0af0bcb77871cc84072fbecbf23c24ee87c34d0b348ba67dc9bad94d8" => :el_capitan
    sha256 "379e7930906d0a05b589ba33b126310b61d46adbaa0dac03249a68ae3d8e5ad4" => :yosemite
  end

  depends_on "node"

  def install
    inreplace "bin/run.js", "npm update -g heroku-cli", "brew upgrade heroku"
    inreplace "bin/run", "node \"$DIR/run.js\"",
                         "#{Formula["node"].opt_bin}/node \"$DIR/run.js\""
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"heroku", "version"
  end
end
