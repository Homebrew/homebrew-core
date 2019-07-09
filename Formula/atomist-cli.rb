require "language/node"

class AtomistCli < Formula
  desc "The Atomist CLI"
  homepage "https://github.com/atomist/cli#readme"
  url "https://registry.npmjs.org/@atomist/cli/-/@atomist/cli-1.6.0.tgz"
  sha256 "0c00e070c8525df747676ea30241c772631c622664b26146f313fe1019778adb"

  bottle do
    sha256 "53839d45fbee5a05b8a307e8f8ec534cb48c70f6bc8fbf88edbd8b0857de8df0" => :mojave
    sha256 "41d2c6679f6cefcc8431f9fed5ea17bcbd8e68fc19df505fe659b717c8fa5713" => :high_sierra
    sha256 "d521a720034d0ab0d02fa090df4c2b852d120a8ef02366a84c077c3ef9b72abe" => :sierra
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
