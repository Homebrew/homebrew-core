require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  # Check if this can be switched to the newest `node` at version bump
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-7.5.0.tgz"
  sha256 "4c0da8e0500cf6d2ca7498d39606ae23c60073253dcbc079c71b9fb783028249"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57f31a9be19d25d56720015030a06512e803a5c5e11a0d035f2ca14029f87641"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57f31a9be19d25d56720015030a06512e803a5c5e11a0d035f2ca14029f87641"
    sha256 cellar: :any_skip_relocation, monterey:       "b3d87db04587d9f375caf80edf830ca5dda3bef9283f2abf32fa85a190f281e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3d87db04587d9f375caf80edf830ca5dda3bef9283f2abf32fa85a190f281e6"
    sha256 cellar: :any_skip_relocation, catalina:       "b3d87db04587d9f375caf80edf830ca5dda3bef9283f2abf32fa85a190f281e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57f31a9be19d25d56720015030a06512e803a5c5e11a0d035f2ca14029f87641"
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
