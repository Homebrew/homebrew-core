class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-9.4.0.tgz"
  sha256 "ffa9b891ea8ed25feeff7447b7f774e9b5d30fcf5c19084fb6973670f1f00002"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "9a63c7efd4f26262656ff10909656bdae9dc41a6175f41f0ab24c38fe4f66ed1"
    sha256 cellar: :any,                 arm64_tahoe:       "9a63c7efd4f26262656ff10909656bdae9dc41a6175f41f0ab24c38fe4f66ed1"
    sha256 cellar: :any,                 arm64_sequoia:     "9a63c7efd4f26262656ff10909656bdae9dc41a6175f41f0ab24c38fe4f66ed1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "26507fd52fbb1381c1cdf5fe2edcae15efb7a7476dfa007c77376642e7753c70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0c089d16268813fb6161a6f5e92041d39e52ea940fcc65b0b00daa40e490e32f"
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *std_npm_args
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    output = shell_output("#{bin}/jhipster info 2>&1")
    assert_match "JHipster configuration not found", output
    assert_match "execution is complete", output

    assert_match version.to_s, shell_output("#{bin}/jhipster --version")
  end
end
