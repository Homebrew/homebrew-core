require "language/node"

class Alexjs < Formula
  desc "Catch insensitive, inconsiderate writing"
  homepage "https://alexjs.com"
  url "https://github.com/get-alex/alex/archive/8.0.0.tar.gz"
  sha256 "681022a4e5a03e15e4aa0a65b417929b1d7d8ce24f6805f90cf442e589d16269"

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
