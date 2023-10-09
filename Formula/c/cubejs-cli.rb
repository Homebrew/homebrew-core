require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.0.tgz"
  sha256 "d6207c3dfd13eeaaab49065e0d47f02930b33845298a5f9aeef5b69b0ab55ca1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "4a996116966878f12f9ab140f9845d2bf0e62a83c7094892434a1d5dbaa366cf"
    sha256 cellar: :any, arm64_ventura:  "4a996116966878f12f9ab140f9845d2bf0e62a83c7094892434a1d5dbaa366cf"
    sha256 cellar: :any, arm64_monterey: "4a996116966878f12f9ab140f9845d2bf0e62a83c7094892434a1d5dbaa366cf"
    sha256 cellar: :any, sonoma:         "dc6c9bb59a4830f34b67e0ab095e00ea06a1bc9db5a6505932bfee045169ed7c"
    sha256 cellar: :any, ventura:        "dc6c9bb59a4830f34b67e0ab095e00ea06a1bc9db5a6505932bfee045169ed7c"
    sha256 cellar: :any, monterey:       "b1697c49f130542203b491e3a5ddca2b687130a4e0cacf55dcb2c0270bd96e33"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
