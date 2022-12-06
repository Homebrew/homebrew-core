require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-7.9.3.tgz"
  sha256 "c76f39732ed3594d07d03a51c3724f10a40c6343f385ddb48caa2ba7ef0a66cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9b42d15ff66e28163a92465d79ce167bd839a66edc77cde76732534903e0b57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6470523be77560242b755bc18af0b91479daea4e60e68409c9a286a6fef4ae2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6470523be77560242b755bc18af0b91479daea4e60e68409c9a286a6fef4ae2"
    sha256 cellar: :any_skip_relocation, ventura:        "95183ad737b1523e5e44ae5e8345b7beba027905268a3f49ba747d7c3ba4479b"
    sha256 cellar: :any_skip_relocation, monterey:       "960ac782a7603c74b684a76fa5288014246ef71817fe05c5d267cbb1d94bc146"
    sha256 cellar: :any_skip_relocation, big_sur:        "960ac782a7603c74b684a76fa5288014246ef71817fe05c5d267cbb1d94bc146"
    sha256 cellar: :any_skip_relocation, catalina:       "960ac782a7603c74b684a76fa5288014246ef71817fe05c5d267cbb1d94bc146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6470523be77560242b755bc18af0b91479daea4e60e68409c9a286a6fef4ae2"
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
