require "language/node"

class ApifyCli < Formula
  include Language::Node::Shebang

  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.19.4.tgz"
  sha256 "4c5b11807e8b38311c76aa9409dd5089f637392e57ac77fba50550280c19fce2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd60b12f94067ec32567dc8a15d69c8450474e550cf8b4e43a0627b6f287f7a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd60b12f94067ec32567dc8a15d69c8450474e550cf8b4e43a0627b6f287f7a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd60b12f94067ec32567dc8a15d69c8450474e550cf8b4e43a0627b6f287f7a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b4c0d2c720fb6dbb1bde62ae5567ecebbdb2536a6220fe42d7067a8138c94c1"
    sha256 cellar: :any_skip_relocation, ventura:        "6b4c0d2c720fb6dbb1bde62ae5567ecebbdb2536a6220fe42d7067a8138c94c1"
    sha256 cellar: :any_skip_relocation, monterey:       "6b4c0d2c720fb6dbb1bde62ae5567ecebbdb2536a6220fe42d7067a8138c94c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fada99333ccdeb9cbaad9cfcca3ffbf20a71b3ca42a5d0ffbcee6442ead5adc"
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
