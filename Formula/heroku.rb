require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.16.15.tgz"
  sha256 "ccbe729ab1bdb405e662775631b1fc558b681bd2bb3a0032630b3f3cf5dcbba4"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "60a1e66d3e35542697fb09de05b9119514d3e6141c633ad5eb77daf99644b967" => :high_sierra
    sha256 "411c7b49ff2faf68fa46e2e5978fb47a43253851b1f76440035e858581967632" => :sierra
    sha256 "4bd6e5c8d5fce40e7766605be900345ed052fdc693db045220c1301556f9b900" => :el_capitan
  end

  depends_on "node"

  def install
    inreplace "bin/run" do |s|
      s.gsub! "npm update -g heroku-cli", "brew upgrade heroku"
      s.gsub! "#!/usr/bin/env node", "#!#{Formula["node"].opt_bin}/node"
    end
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"heroku", "version"
  end
end
