require "language/node"

class AtomistCli < Formula
  desc "The Atomist CLI"
  homepage "https://github.com/atomist/cli#readme"
  url "https://registry.npmjs.org/@atomist/cli/-/@atomist/cli-1.8.0.tgz"
  sha256 "64bcc7484fa2f1b7172984c278ae928450149fb02b750f79454b1a6683d17f62"

  bottle do
    sha256 "a1f611e6f70a5dbdf886c6cf0a2aec9d6024a12e2e768e1f0230087babe7b3d6" => :mojave
    sha256 "f109033a8fa80bcf777e053dfae07b84fd134c40d1ed356dbedddfad1e7b85f8" => :high_sierra
    sha256 "314c7129a7b8f2e37ab46324dba4423c8c7712b99f1bd8f0dd5eb5904d9d3e3e" => :sierra
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
