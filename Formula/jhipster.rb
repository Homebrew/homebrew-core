require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  # Check if this can be switched to the newest `node` at version bump
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-7.2.0.tgz"
  sha256 "98b95b4b379750822e596fd937c215a21e85345eaf83c0bcdd7d4c755520f785"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "456d80527406219cc94629f0a5409b0f1c0d4c0939e3b2d8e3eeeb181af6afe9"
    sha256 cellar: :any_skip_relocation, big_sur:       "e66245e7f20ae029c1575ad8d93521ef8c4bef280a5258334379d41a33c41907"
    sha256 cellar: :any_skip_relocation, catalina:      "053d27b5a22c1ebea7006a325846f6bb7bc8162681c7a2105498338a773568d2"
    sha256 cellar: :any_skip_relocation, mojave:        "dd95ce80f3862b6577bbd0fe920cb22691ae04316623285f399316234c506c0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a12d04782b4a8c5d489125a9a66a4498b4da99bcda87cdf11b03b6839a6fe073"
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
