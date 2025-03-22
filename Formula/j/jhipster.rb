class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-8.9.0.tgz"
  sha256 "57e7c0730c9fd2abf2c3228cb4451c91f09baf2d54df73a1bbc1fc608ff455b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "943c4bbd21047b795f81f828c44e229f01d609fe84f3aeb93a0992d9b1cb045d"
    sha256 cellar: :any,                 arm64_sonoma:  "943c4bbd21047b795f81f828c44e229f01d609fe84f3aeb93a0992d9b1cb045d"
    sha256 cellar: :any,                 arm64_ventura: "943c4bbd21047b795f81f828c44e229f01d609fe84f3aeb93a0992d9b1cb045d"
    sha256 cellar: :any,                 sonoma:        "b26373ca5af6be83cfd967318a3b4ddcbb78d6794c417f533a5d33e7e791d71b"
    sha256 cellar: :any,                 ventura:       "b26373ca5af6be83cfd967318a3b4ddcbb78d6794c417f533a5d33e7e791d71b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ba07fb865420067252689d62ea6897be4da46d6e994f8a6cbc5ae97eeb81d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfd6136d147b387493bbe8957b86f8449a03202b1407c28285b707d941fecd00"
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *std_npm_args
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    output = shell_output("#{bin}/jhipster info 2>&1")
    assert_match "JHipster configuration not found", output
    assert_match "execution is complete", output

    assert_match version.to_s, shell_output("#{bin}/jhipster --version")
  end
end
