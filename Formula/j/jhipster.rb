class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-8.10.0.tgz"
  sha256 "8b0a78fb7f1872252edf419e4885ddc7b91affd0353385fdd5ffc3046aebd2c0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6df1d0107ef5166a91fc845ff1cffb9914fbeff961384a218c4e7d2fbd0a0ab4"
    sha256 cellar: :any,                 arm64_sonoma:  "6df1d0107ef5166a91fc845ff1cffb9914fbeff961384a218c4e7d2fbd0a0ab4"
    sha256 cellar: :any,                 arm64_ventura: "6df1d0107ef5166a91fc845ff1cffb9914fbeff961384a218c4e7d2fbd0a0ab4"
    sha256 cellar: :any,                 sonoma:        "3d857aae71d60c665a3382e94b9104d9f8ca2ec1ff6ce30c7ae3bac4f00f5041"
    sha256 cellar: :any,                 ventura:       "3d857aae71d60c665a3382e94b9104d9f8ca2ec1ff6ce30c7ae3bac4f00f5041"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75f0a79e3fd2ac7091cf36cf7478a2f05cc4cdc246b856777c356b44e0dad1e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8da7fab88b98f96fae7cd21fa0c78c741b21ac9015929a13451d1780ffca401d"
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
