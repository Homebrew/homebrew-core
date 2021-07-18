require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.0.tgz"
  sha256 "022d8f4a33c691173147b5bd01a1388220f8ab6053b8385f2afd20df68cea03a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fc50ee9bb61454c34ede471d9979b44231c4d95dba71107bb005e85b329a39d6"
    sha256 cellar: :any_skip_relocation, big_sur:       "be162161c00e23a009ad2e206d8ba98e11d403fe921c0e0938c741d86b207ed9"
    sha256 cellar: :any_skip_relocation, catalina:      "be162161c00e23a009ad2e206d8ba98e11d403fe921c0e0938c741d86b207ed9"
    sha256 cellar: :any_skip_relocation, mojave:        "be162161c00e23a009ad2e206d8ba98e11d403fe921c0e0938c741d86b207ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc50ee9bb61454c34ede471d9979b44231c4d95dba71107bb005e85b329a39d6"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
