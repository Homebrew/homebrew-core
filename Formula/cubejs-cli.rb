require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.22.0.tgz"
  sha256 "2d2b573e03d92228cac809d9a87a564d81e83c585622f6e317ca49ecfa87b9e2"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "940c68f3b3a7f7e80a831bd845c41021ebff0766fbab0fe46ce7d4bea966a286" => :catalina
    sha256 "8e7b44c5e5894995e085dbd025ac95436daf69ccf06096b263131a004454eebc" => :mojave
    sha256 "15ea12ff09f18ead0d9cb01076b13c8b9967996849718a33292163e6292beed0" => :high_sierra
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
