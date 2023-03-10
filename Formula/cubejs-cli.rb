require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.4.tgz"
  sha256 "998aef9c9d1947ed684d7524dafad4cd461178fa51c470aa1c0b032980cd899b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b70584e232c450c3018eff6a11955b64a96e07831a10377c7adc1e8ae1c41bb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b70584e232c450c3018eff6a11955b64a96e07831a10377c7adc1e8ae1c41bb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b70584e232c450c3018eff6a11955b64a96e07831a10377c7adc1e8ae1c41bb5"
    sha256 cellar: :any_skip_relocation, ventura:        "a340c11af5bc0a6db2d06ea712f663d6e80cd19bcb6d0ef6b149bf44b3ef065b"
    sha256 cellar: :any_skip_relocation, monterey:       "a340c11af5bc0a6db2d06ea712f663d6e80cd19bcb6d0ef6b149bf44b3ef065b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a340c11af5bc0a6db2d06ea712f663d6e80cd19bcb6d0ef6b149bf44b3ef065b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b70584e232c450c3018eff6a11955b64a96e07831a10377c7adc1e8ae1c41bb5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
