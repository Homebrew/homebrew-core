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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "37810f4f38600d90a53173949ba3eb8adb25820dd568d99e82f286f815ae38e6"
    sha256 cellar: :any_skip_relocation, big_sur:       "f349ed13bdf8df18006d534fb6d7ff4829eaa718de2d70b64bc81729991186ef"
    sha256 cellar: :any_skip_relocation, catalina:      "87c266c3e874222e0d4b5323514c05e0b65bd30c46656c84d39658354ee87286"
    sha256 cellar: :any_skip_relocation, mojave:        "13daac9bfb8bbb368fdd4d4670c870e6ceb2d43c10990219a790a41e697aaa4c"
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
