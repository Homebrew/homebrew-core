require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.25.2.tgz"
  sha256 "6aeb4bab1148a36824083c9751ba7b9335972746b9ee03a5527d9a6f1c578e29"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b368d5f45e05ef4be1c7bdcdce8c1e0cab564651eea873d9250e9ff5df4e56cc" => :big_sur
    sha256 "252bf0f04c3199c838bdfb42d2f835b134b4ed712607927f9f6b7a11c8626009" => :arm64_big_sur
    sha256 "b243c67e2877f090b730111751376368e88fbb9c1690108cb3d4beee23938f27" => :catalina
    sha256 "c34f1f56c3e9d7fd6358621d072a205b96c7bece271cbd77e2fceb5c41b3b8d9" => :mojave
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
