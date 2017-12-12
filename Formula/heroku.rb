require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.40.tgz"
  sha256 "91bfa53edfd4f8cdaee73054fd66e6a9afe689f74bf2af621fe1ffdd55e4e2da"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7470c636a0e3bde0268c834587edcff35934e04498471816231e04f231dd4c73" => :high_sierra
    sha256 "a2bb6b40b7692b4c1ec215d8782e32578aeded99f5488c9ef3a102484334298e" => :sierra
    sha256 "ee07df9012a9ca22f77ff9a84a58c8f821a3f016363efed56ac6d3cc9530702f" => :el_capitan
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
