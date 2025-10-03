class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-8.11.0.tgz"
  sha256 "6b78675f33769a5581b716bebbeb8ef651e0be1a93c5010478cf9d7b0c1a0c1e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "545fb346129da0709093da8121604b7b33695cc72da5aea9cfc348dc99010699"
    sha256 cellar: :any,                 arm64_sequoia: "b542ed1ef9eeb700b746105c2a49eaba3395328332796085f3ea15d7352ae900"
    sha256 cellar: :any,                 arm64_sonoma:  "b542ed1ef9eeb700b746105c2a49eaba3395328332796085f3ea15d7352ae900"
    sha256 cellar: :any,                 arm64_ventura: "b542ed1ef9eeb700b746105c2a49eaba3395328332796085f3ea15d7352ae900"
    sha256 cellar: :any,                 sonoma:        "0398b0c32194ef0283ab8f10c82b6b21b78bd83973eb792f34db42788c91ee51"
    sha256 cellar: :any,                 ventura:       "0398b0c32194ef0283ab8f10c82b6b21b78bd83973eb792f34db42788c91ee51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d98b6871e0ae6b7f5b09e464e22f1eafc67ff56805370961800c9a20ebb56a49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1836ddf0f3d7cafecc18aed020773448e2a88c86c6ff2f2d195d0b2fa9800cb6"
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
