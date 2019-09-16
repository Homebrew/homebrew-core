require "language/node"

class AtomistCli < Formula
  desc "The Atomist CLI"
  homepage "https://github.com/atomist/cli#readme"
  url "https://registry.npmjs.org/@atomist/cli/-/@atomist/cli-1.8.0.tgz"
  sha256 "64bcc7484fa2f1b7172984c278ae928450149fb02b750f79454b1a6683d17f62"

  bottle do
    sha256 "2de51e5f7d118cbf6f8edf37bcf9843d6e2bca358417985014713074643bfa5d" => :mojave
    sha256 "1d962430e7476140660a05e44b5700131aab48b217aa982a1a921e701457e95f" => :high_sierra
    sha256 "a826c40c988dd72266fea5814617c93cc0365b18f6db9d0a70438e9128c83b94" => :sierra
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
