require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku/-/heroku-7.0.12.tgz"
  sha256 "894cc48db3128b2cc899f808d7098f5d0937936aef64105034c3b69576b449a7"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e00c292d67706a9f10a455503e891dfd05d05bdffe829a58d6b8a9c8bfb655d" => :high_sierra
    sha256 "51d320fea752aa8baa4ad0be72da1dcb1b4a3f38e79019e32a539adef4eb1780" => :sierra
    sha256 "b5c972cafb5e708171c6cb7d501b3fef6697dfb047d838b3acb59767a71cbd1d" => :el_capitan
  end

  depends_on "node"

  def install
    inreplace "bin/run", "#!/usr/bin/env node",
                         "#!#{Formula["node"].opt_bin}/node"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"heroku", "version"
  end
end
