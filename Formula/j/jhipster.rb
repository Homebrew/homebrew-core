class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-9.1.0.tgz"
  sha256 "9cc46408f0abc17971898e5fcfa2e10732576c7970bc8a425e5926f74b342458"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2defc1015a258ae8a3cc46aca42600d57b0699ebe0aa68329028076b63cedd39"
    sha256 cellar: :any,                 arm64_sequoia: "20cb521f55f2aadeebd71a6c0c4dca29f2b2c5c3500ccdf8c943a58866419c3c"
    sha256 cellar: :any,                 arm64_sonoma:  "20cb521f55f2aadeebd71a6c0c4dca29f2b2c5c3500ccdf8c943a58866419c3c"
    sha256 cellar: :any,                 sonoma:        "14b75d248bca615016be11b4448b1e93a2232121316216d5f0469165ec969d18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fac851f600c549ca28f49ef149a3a98409b7a51615ed4323f7bb6068adf23b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f0229716d12c047c203c3ca76765453c103c711a0a19054a49e023e3512a018"
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
