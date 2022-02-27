require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  # Check if this can be switched to the newest `node` at version bump
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-7.7.0.tgz"
  sha256 "561c55ad290f8325093c791e4e2125fbbce49f1c58031246934a988bafde3e94"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18f7a7cba3361f699a83b7bec287749f510f865d6e7c0fed42d07de86cafd370"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18f7a7cba3361f699a83b7bec287749f510f865d6e7c0fed42d07de86cafd370"
    sha256 cellar: :any_skip_relocation, monterey:       "637d7a499fd314ad86522957c5f2a56334b1a6cb03cec2ddb13177c6bcdd4350"
    sha256 cellar: :any_skip_relocation, big_sur:        "637d7a499fd314ad86522957c5f2a56334b1a6cb03cec2ddb13177c6bcdd4350"
    sha256 cellar: :any_skip_relocation, catalina:       "637d7a499fd314ad86522957c5f2a56334b1a6cb03cec2ddb13177c6bcdd4350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18f7a7cba3361f699a83b7bec287749f510f865d6e7c0fed42d07de86cafd370"
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
