require "language/node"

class AtomistCli < Formula
  desc "The Atomist CLI"
  homepage "https://github.com/atomist/cli#readme"
  url "https://registry.npmjs.org/@atomist/cli/-/@atomist/cli-1.3.0.tgz"
  sha256 "313b5f356bee3f77b800ebda3f4225813a6b1453fe26624cacbad82ba5b5d9d7"

  bottle do
    sha256 "8ba312dfde4af7f2ede49949cd1315974e18dd1d5fafe4ff5afb1c4283e7e716" => :mojave
    sha256 "d01e3c646a708d245d6b097149bdf4edc0d27f1c91161d3a0822a0c8637f4977" => :high_sierra
    sha256 "0daaa3d500d196b0e7f1defbed4c7f5ca93e0afbe2813be046fdb38b3ab38b69" => :sierra
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

    run_output = shell_output("#{bin}/atomist 2>&1")
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
