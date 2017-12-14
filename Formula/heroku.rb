require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.42.tgz"
  sha256 "37867b813523c915fe8e4bc41afcfe3c70241ad71031c0ebbcaa8b1c0ac42935"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd07815b90586a153847173eea9046e1017bcc2fdb4344f361822c392244aa5e" => :high_sierra
    sha256 "b66fc685f5afd92072d1cd29cb8e84acfbfc1d7a5547bbb5b34a8d843c929b80" => :sierra
    sha256 "7c93ca10cf36a0298b5b169dee077c51b29be841e49afe5cc70b9f2d22296953" => :el_capitan
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
