require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  # Check if this can be switched to the newest `node` at version bump
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-7.1.0.tgz"
  sha256 "0f91788a1c74ce26ede20f34f0c1e3cee4f290f6051b3f6cd5c6d8f27421f072"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "47b985bbb3cc58b4529c7c763f19e4dfe0bcab41816fbae0246365c8cb18a407"
    sha256 cellar: :any_skip_relocation, big_sur:       "c856446ea5893d7f9120db10c130e3e7761b4417ec2e71c1d1296e2c96d7472f"
    sha256 cellar: :any_skip_relocation, catalina:      "01941f8e88b86ac4bafebcaaaa3d1aa431955595d42d2bfe012c732b42c026e5"
    sha256 cellar: :any_skip_relocation, mojave:        "ce2ac933f28fef60f8b3248146ecc661f7a7c5ba4564909c5ecd2d47d9b43b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4eb1430ce15672c3038934a6073ddb096a02176b77facc2ff218103672b65b4"
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
