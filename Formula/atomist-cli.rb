require "language/node"

class AtomistCli < Formula
  desc "The Atomist CLI"
  homepage "https://github.com/atomist/cli#readme"
  url "https://registry.npmjs.org/@atomist/cli/-/@atomist/cli-1.6.1.tgz"
  sha256 "b39f35a9fb3df8e994840f381848f4cc3d209c8d10da315d314e3aa2ae03e643"

  bottle do
    sha256 "d97ef831aabff6973eac7b8cb4e8897d2f9fe3d8e4018caa5f1c8967b31b2578" => :mojave
    sha256 "e2f4ddb68c20300ff2b813d4ca5837d07461128a76464e454ed2bdb7299e8bfa" => :high_sierra
    sha256 "ba75cca5cecc972f32c8e83da84c81f1c5de55a4f258d47c90c13ccdfa3966b5" => :sierra
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
