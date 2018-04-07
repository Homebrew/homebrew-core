require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.16.8.tgz"
  sha256 "c3de09839cdfc9c4205290656b99983aa5c70ce96ac10d0b2906c85eb61573b8"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "67d9a7b44cee6fa9c95b9465c5adf25c049290df8d314c87aaa5c596104d5ebe" => :high_sierra
    sha256 "3d867ac3b52376c4f881c474d800e2e15c1b9b6e1f49aee06ebbbeb471e13973" => :sierra
    sha256 "38df90b1e8fda89a9d8b632ade18f306cf694c9772b3c6a4e0e33f1a198fd6f8" => :el_capitan
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
