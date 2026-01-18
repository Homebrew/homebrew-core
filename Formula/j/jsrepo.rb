class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.0.11.tgz"
  sha256 "4c873d7aacd97a8a17293626048faa5193b05d85e395daa22d44d74990fb6e0c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cad4798d077b1fdd48f01b8732b3112b84754a7f04ae926df60b5ddccbf100bf"
    sha256 cellar: :any,                 arm64_sequoia: "1991a7923ddee99437825fe1548abc3a1078379ef83de59bfd58dfb079b931a5"
    sha256 cellar: :any,                 arm64_sonoma:  "1991a7923ddee99437825fe1548abc3a1078379ef83de59bfd58dfb079b931a5"
    sha256 cellar: :any,                 sonoma:        "b5c37ca74480726e200d2fed19806956de15b65710651a78229847bb13d24f69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "604ac53f45218224f80b70788c468cae59b4c5f821ad84da1793238dad4dc7f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7df1986f0014e86209419aaef4a6e504a970ede493e81b4ae58e4e93f11b3584"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0"
      }
    JSON
    system bin/"jsrepo", "init", "--yes"
  end
end
