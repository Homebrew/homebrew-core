require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.28.tgz"
  sha256 "1488fa555c264f2990ac4330344acaafcf8b55168d6fe3278264de5175044968"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60374cee8dd9ec114abdd3de38a3bc90218ef1e9d4fc7e8657c09255332a93d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60374cee8dd9ec114abdd3de38a3bc90218ef1e9d4fc7e8657c09255332a93d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60374cee8dd9ec114abdd3de38a3bc90218ef1e9d4fc7e8657c09255332a93d3"
    sha256 cellar: :any_skip_relocation, ventura:        "46371a8790a0f159a252a0ea80f674cde8175a632b94d1e4fbda811b5b757538"
    sha256 cellar: :any_skip_relocation, monterey:       "46371a8790a0f159a252a0ea80f674cde8175a632b94d1e4fbda811b5b757538"
    sha256 cellar: :any_skip_relocation, big_sur:        "46371a8790a0f159a252a0ea80f674cde8175a632b94d1e4fbda811b5b757538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60374cee8dd9ec114abdd3de38a3bc90218ef1e9d4fc7e8657c09255332a93d3"
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
