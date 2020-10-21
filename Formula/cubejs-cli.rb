require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.22.1.tgz"
  sha256 "aa96add4ccb52e8096e390f94cfaf8916bbe6c47bc5c761e132d75eaf81538df"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "72fdbb82dbd1c24ce2679e732b0c7e881e89242fdb24508cf5069bb3f051c6b9" => :catalina
    sha256 "d92cc82c29fbcf03e19407593a22c7b756ee0936adfb5cbe1fabea0a0146ba16" => :mojave
    sha256 "7c551d76d490e871b23b1f1ae18ce78e8a2415521704c18bf8de226081eb7976" => :high_sierra
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
