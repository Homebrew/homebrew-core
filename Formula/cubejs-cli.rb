require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.25.6.tgz"
  sha256 "fca63b313d8d040ec789e4ba7d06823b40749e52970286ff0bc21ab9d4d876f5"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d6bbb11b88186cc0c62108b17b5b552e8d9fd9661dd96e692a456483ad4710c2" => :big_sur
    sha256 "25350ce4b581ee1cd0f7aaf41c893f45dafbfd80151fdc546e7bbe29d7e9e4af" => :arm64_big_sur
    sha256 "2b9d651713921d09d7b5dee8b2524fd820549a2dc0d19ca2e80c255c2649f23e" => :catalina
    sha256 "b35db033f29041e05f722318645ed455d96bfe125224e9270d2e8c34a988160c" => :mojave
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
