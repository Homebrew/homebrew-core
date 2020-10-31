require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.23.3.tgz"
  sha256 "35c9b3430f443faeea43695e5506cecc04869f569b6cf90f218598dbd024ee85"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cec8bae27fba165c1ab42a436e1bb039cf886bb80483d0adbfe3b740dbf596a4" => :catalina
    sha256 "3a3a3aecede9ae1f96df23c852bd17abdeb33fee32945cf0dd698f230f465530" => :mojave
    sha256 "1f2a93491f1d95a456187df851d72f391b551a6331dcf18253645d0ea4eb4799" => :high_sierra
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
