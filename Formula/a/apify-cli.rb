require "language/node"

class ApifyCli < Formula
  include Language::Node::Shebang

  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.18.1.tgz"
  sha256 "ee638e7cae1947034602e656031b47e3a2ba1ab70e033097ab72ce9e9d911f1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5dd67c07137004d0afe93eab2070c6b18544de201b14eefd8d996846bc3afd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5dd67c07137004d0afe93eab2070c6b18544de201b14eefd8d996846bc3afd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5dd67c07137004d0afe93eab2070c6b18544de201b14eefd8d996846bc3afd3"
    sha256 cellar: :any_skip_relocation, ventura:        "fa35d221e286aaebc337065d405a82585ffecf45febbcd0851fdee4731c24e79"
    sha256 cellar: :any_skip_relocation, monterey:       "fa35d221e286aaebc337065d405a82585ffecf45febbcd0851fdee4731c24e79"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa35d221e286aaebc337065d405a82585ffecf45febbcd0851fdee4731c24e79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a2198dba2bc75ac6323b0c2ebe1c58062665204f9c5c4fbae9dbc8478d385da"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    # We have to replace the shebang in the main executable from "/usr/bin/env node"
    # to point to the Homebrew-provided `node`,
    # because otherwise the CLI will run with the system-provided Node.js,
    # which might be a different version than the one installed by Homebrew,
    # causing issues that `node_modules` were installed with one Node.js version
    # but the CLI is running them with another Node.js version.
    rewrite_shebang detected_node_shebang, libexec/"lib/node_modules/apify-cli/src/bin/run"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # Test that the Apify CLI is at all installed and working
    assert_match "apify-cli/#{version}", shell_output("#{bin}/apify --version")
    # Test that the CLI can initialize a new actor
    system "#{bin}/apify", "init", "testing-actor"
    assert_predicate testpath/".actor/actor.json", :exist?
  end
end
