require "language/node"

class Alexjs < Formula
  desc "Catch insensitive, inconsiderate writing"
  homepage "https://alexjs.com"
  url "https://github.com/get-alex/alex/archive/8.0.1.tar.gz"
  sha256 "c095af21d1d24a6609813f8bc78d16d8aa62c1b37621029a3b3cb3d331533414"

  bottle do
    cellar :any_skip_relocation
    sha256 "0be908a2f46c538275454731e982b789894570434f522aa1e09d420bcc88049a" => :catalina
    sha256 "3d24eaeaae4f251c8d13bb1f112623d9b2b248dd92569dd89afaf924677add14" => :mojave
    sha256 "f029bb8ba6e5938fa9ff314c348ae3f1e9f55d8639e7a3a9103ab0e177fd816a" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.txt").write "garbageman"
    assert_match "garbage collector", shell_output("#{bin}/alex test.txt 2>&1", 1)
  end
end
