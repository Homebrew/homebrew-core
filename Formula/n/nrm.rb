class Nrm < Formula
  desc "NPM registry manager, fast switch between different registries"
  homepage "https://github.com/Pana/nrm"
  url "https://registry.npmjs.org/nrm/-/nrm-2.1.0.tgz"
  sha256 "cdad289ac8e72878ab72575ee61551b5d1cb6334097d6904f5ce30603ae5c74f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cfc2f178795240d70ba83bfba10792921700bca2404c5648d5db4c627404455"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cfc2f178795240d70ba83bfba10792921700bca2404c5648d5db4c627404455"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0cfc2f178795240d70ba83bfba10792921700bca2404c5648d5db4c627404455"
    sha256 cellar: :any_skip_relocation, sonoma:        "1439588d93796b84788d72ac494127f1297a3a9d9fa7e107e41385f1287b0e62"
    sha256 cellar: :any_skip_relocation, ventura:       "1439588d93796b84788d72ac494127f1297a3a9d9fa7e107e41385f1287b0e62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cfc2f178795240d70ba83bfba10792921700bca2404c5648d5db4c627404455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cfc2f178795240d70ba83bfba10792921700bca2404c5648d5db4c627404455"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "SUCCESS", shell_output("#{bin}/nrm add test http://localhost")
    assert_match "test --------- http://localhost/", shell_output("#{bin}/nrm ls")
    assert_match "SUCCESS", shell_output("#{bin}/nrm del test")
  end
end
