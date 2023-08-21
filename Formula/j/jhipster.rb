require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-7.9.3.tgz"
  sha256 "c76f39732ed3594d07d03a51c3724f10a40c6343f385ddb48caa2ba7ef0a66cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5023ca884b48c2c31472f38182176581b76b453f604280bc8cf065bf44bd9e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5023ca884b48c2c31472f38182176581b76b453f604280bc8cf065bf44bd9e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5023ca884b48c2c31472f38182176581b76b453f604280bc8cf065bf44bd9e2"
    sha256 cellar: :any_skip_relocation, ventura:        "1a870835098f2a8ce7957000f69ec7c5ed93cfdee6d28279f781b10d646f2dbf"
    sha256 cellar: :any_skip_relocation, monterey:       "1a870835098f2a8ce7957000f69ec7c5ed93cfdee6d28279f781b10d646f2dbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a870835098f2a8ce7957000f69ec7c5ed93cfdee6d28279f781b10d646f2dbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5023ca884b48c2c31472f38182176581b76b453f604280bc8cf065bf44bd9e2"
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    # Bump dependent package yeoman-environment to 3.11.0 to work around
    # `ERR_PACKAGE_PATH_NOT_EXPORTED` error. Remove on next release.
    inreplace "package.json",
      '"yeoman-environment": "3.10.0"',
      '"yeoman-environment": "3.11.0"'
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
