require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.40.tgz"
  sha256 "91bfa53edfd4f8cdaee73054fd66e6a9afe689f74bf2af621fe1ffdd55e4e2da"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a37c4dbe5fe093e8655410c6c24d8234792183eabcb37ea6992bd1b443d6b4b7" => :high_sierra
    sha256 "276539198c2929f57236fba8780ae666a92ca16faf91f29aea57c04c526cc2b0" => :sierra
    sha256 "9ebbcc06c6cc7dbc9a74b31240ea955d9205deb1e84e13536f5abdd60c1516f0" => :el_capitan
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
