require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  # Check if this can be switched to the newest `node` at version bump
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-7.0.1.tgz"
  sha256 "5e92b04561905adee9e91e4f2f8f12dd93d5ab389556753e09ee23fe34035873"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5936f76445f075c195b45b857fbef95cf7c01bf56f751d8f365a905e682596bd"
    sha256 cellar: :any_skip_relocation, big_sur:       "dbd46ebc8d781c5080f672bd434099672d030564f1ba24fd4c67221d8c47a6f0"
    sha256 cellar: :any_skip_relocation, catalina:      "0a206a02b69010d2aaf8ad762ab9ca91950fd8681e3b9df4fccbf9ed7dfa54e2"
    sha256 cellar: :any_skip_relocation, mojave:        "883ad7178c717dd8ecf7366cd39023d025092e5f9f60122a8013d2f8bfe4028c"
  end

  depends_on "node@14"
  depends_on "openjdk"

  def install
    node = Formula["node@14"]
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    env = { PATH: "#{node.opt_bin}:$PATH" }
    env.merge! Language::Java.overridable_java_home_env
    bin.env_script_all_files libexec/"bin", env
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
