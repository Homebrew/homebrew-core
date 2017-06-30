require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.2.0.tgz"
  sha256 "e03e7f023a1c7eeebd45058e3b698708fe36ce703d706489222083af8681edde"

  bottle do
    cellar :any_skip_relocation
    sha256 "0534cedbf5d99c5e4a3035ecbdf250802089472c3f0c4d45a70db6494577915c" => :sierra
    sha256 "393029f06dab553b0820661e841c187169c51ff64fe6b52e84f23986c24adf05" => :el_capitan
    sha256 "ba1ca30e540d6d3064aff47f976295226568ff5bf8cf9240de127377310c9bb8" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/@angular/cli/-/cli-1.3.0-beta.0.tgz"
    version "1.3.0-beta.0"
    sha256 "8d82cba6783c24bfc37cdeb95371a725f251aa2db3c426ba8a147eb62f308650"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "--skip-install", "angular-homebrew-test"
    assert File.exist?("angular-homebrew-test/package.json"), "Project was not created"
  end
end
