require "language/node"

class ApifyCli < Formula
  include Language::Node::Shebang

  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.19.3.tgz"
  sha256 "1ff99d74350a97e44fe158de4bf921d392420090e295d22dd0911430c9175b3a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "660380298703db6f2ca2466918799e5a52fb1f69569e2b95e2aff0a8aa148e26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "660380298703db6f2ca2466918799e5a52fb1f69569e2b95e2aff0a8aa148e26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "660380298703db6f2ca2466918799e5a52fb1f69569e2b95e2aff0a8aa148e26"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5f76e292228716f457829ba04c7cbc3e381e093d9b66056a0669708e2e1ce4c"
    sha256 cellar: :any_skip_relocation, ventura:        "a5f76e292228716f457829ba04c7cbc3e381e093d9b66056a0669708e2e1ce4c"
    sha256 cellar: :any_skip_relocation, monterey:       "a5f76e292228716f457829ba04c7cbc3e381e093d9b66056a0669708e2e1ce4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c971ecf9877daecc47a51952d3b51a004128c213859c1944843c64190236e713"
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
