class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-9.0.0.tgz"
  sha256 "3785dd5302ca1b3ef10dd061d51320220b0b67effa5d8ba340c133d66c2c887f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ad22b413db1ecfc25d480d6dd863620bfaebafa9521dfee771231facf3e9f078"
    sha256 cellar: :any,                 arm64_sequoia: "dbeaeebbe81a851ba31a2e77f23610f363248814bb753d805cc957e71bc86520"
    sha256 cellar: :any,                 arm64_sonoma:  "dbeaeebbe81a851ba31a2e77f23610f363248814bb753d805cc957e71bc86520"
    sha256 cellar: :any,                 sonoma:        "c296567cda4ebc31a69aafe7039b2982e952ec8b4ef43fdf357f964239b383da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d68bd3f1cfcc119ec15b790a978a3c71a11d4125e4236dcde02b693043a4acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3de941726eedc92628ddea5d8fabc695dc92aea0065129e822edf6d799b9a8ed"
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
