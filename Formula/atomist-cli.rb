require "language/node"

class AtomistCli < Formula
  desc "Unified command-line tool for interacting with Atomist services"
  homepage "https://github.com/atomist/cli#readme"
  url "https://registry.npmjs.org/@atomist/cli/-/cli-1.8.0.tgz"
  sha256 "64bcc7484fa2f1b7172984c278ae928450149fb02b750f79454b1a6683d17f62"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256                               arm64_big_sur: "aa7a1df34f9d6914158696305ef167f422ac4571137e01483e00bc4f637c251c"
    sha256                               big_sur:       "6dd88e8522cd4cf5d53b17f796aef1eca9cbe1c602c00c892d2f30eb73db0d39"
    sha256                               catalina:      "c622ee3ba1742b49887892d30cead992cb34f4f28e68626b03b20a73bd88ba9d"
    sha256                               mojave:        "d5f0927cbfcf78438a0affe17488467727659c5caf9de3a65f9ed565bd23529c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08b42e1e9255b4ffe29eb1efdbeb718698d0faf5274b5799c220e040ea0ced6e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    bash_completion.install "#{libexec}/lib/node_modules/@atomist/cli/assets/bash_completion/atomist"
  end

  test do
    assert_predicate bin/"atomist", :exist?
    assert_predicate bin/"atomist", :executable?
    assert_predicate bin/"@atomist", :exist?
    assert_predicate bin/"@atomist", :executable?

    run_output = shell_output("#{bin}/atomist 2>&1", 1)
    assert_match "Not enough non-option arguments", run_output
    assert_match "Specify --help for available options", run_output

    version_output = shell_output("#{bin}/atomist --version")
    assert_match "@atomist/cli", version_output
    assert_match "@atomist/sdm ", version_output
    assert_match "@atomist/sdm-core", version_output
    assert_match "@atomist/sdm-local", version_output

    skill_output = shell_output("#{bin}/atomist show skills")
    assert_match(/\d+ commands are available from \d+ connected SDMs/, skill_output)
  end
end
