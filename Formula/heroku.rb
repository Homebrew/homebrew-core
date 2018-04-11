require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.16.12.tgz"
  sha256 "934395c3aa9ddfcd9ab4c160674e32019234bc87a1376da7e5a921c6651031b8"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7567c40c2742688453be3fc64e417933cc2fa52ae6720d80bce605ee2a707461" => :high_sierra
    sha256 "fe67fb8f9238a43b4c25fbf3406bb22bbb7dc7ba44338744706ea3dad20e3e7c" => :sierra
    sha256 "a6d2e6993e8e0363f56378e785d7da2f582aa10293fdb6c89a9b7d28da00574c" => :el_capitan
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
