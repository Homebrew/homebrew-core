require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.48.tgz"
  sha256 "23037ad694e64887ac2fe2bd26bc20ed54977bc6739cb20802feacf2265272c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aebcfd8166bf63ee3a2fb2f8222dc8a8b7d4f8ea2ce1d260270adb04db353e14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aebcfd8166bf63ee3a2fb2f8222dc8a8b7d4f8ea2ce1d260270adb04db353e14"
    sha256 cellar: :any_skip_relocation, monterey:       "ab4930bedd57fc48daf589f617e9f34ae1c2b03bc82413b6f7453b393d1de1dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab4930bedd57fc48daf589f617e9f34ae1c2b03bc82413b6f7453b393d1de1dd"
    sha256 cellar: :any_skip_relocation, catalina:       "ab4930bedd57fc48daf589f617e9f34ae1c2b03bc82413b6f7453b393d1de1dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aebcfd8166bf63ee3a2fb2f8222dc8a8b7d4f8ea2ce1d260270adb04db353e14"
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
