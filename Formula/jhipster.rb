require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.10.5.tgz"
  sha256 "3d6ac98e1e777f9f7a33a21a01f4f181a8d9252acb46003a0e850fb8c62bc918"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "02bd1b4b163a00a08af7c15e49b60cf141903cf235c75f89daafe083fa07d4ef" => :big_sur
    sha256 "b0c8ea8fefe09ce1202c0643a25b94a337a2848f777f630d39461ebf33c95bd8" => :arm64_big_sur
    sha256 "4ca44dc77bab71951af8df0ecd0c2ff4c42ced99da51489eb762dd5811930105" => :catalina
    sha256 "dc57fc139d909b7da4f0c9a0d3fd8f13aadbd1b41daa4036377f8ce236d5aad9" => :mojave
    sha256 "faf1d7553a95d40e7a7efb0115c811633f4b436eee9776eab9a41de70df47e20" => :high_sierra
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
