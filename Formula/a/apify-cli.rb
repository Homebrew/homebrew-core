require "language/node"

class ApifyCli < Formula
  include Language::Node::Shebang

  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.19.5.tgz"
  sha256 "bddd03175b0e542737e44ef246f5f7f195901ae4c27b42cd4f9811ee532b3849"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98f2cb466511dd3f1130280dc75466a800fa62defffe865dbe2aabc3ed7cecc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98f2cb466511dd3f1130280dc75466a800fa62defffe865dbe2aabc3ed7cecc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98f2cb466511dd3f1130280dc75466a800fa62defffe865dbe2aabc3ed7cecc8"
    sha256 cellar: :any_skip_relocation, sonoma:         "7dc8c00e67d5bce9d19c545d0218db05008890703cb2fba118942a08e26b85b0"
    sha256 cellar: :any_skip_relocation, ventura:        "7dc8c00e67d5bce9d19c545d0218db05008890703cb2fba118942a08e26b85b0"
    sha256 cellar: :any_skip_relocation, monterey:       "7dc8c00e67d5bce9d19c545d0218db05008890703cb2fba118942a08e26b85b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "deef254922b4c4a2562bda5d2e990b5924cce84474681114a6543f3dba0bbb67"
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
    output = shell_output("#{bin}/apify init -y testing-actor")
    assert_match "Success: The Apify actor has been initialized", output
    assert_predicate testpath/"storage/key_value_stores/default/INPUT.json", :exist?

    assert_match version.to_s, shell_output("#{bin}/apify --version")
  end
end
