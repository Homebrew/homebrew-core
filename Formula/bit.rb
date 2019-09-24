require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.4.0.tgz"
  sha256 "03b31e947012d32baddd446142beac053e829281466f4a1689f1d98b450e22a1"
  head "https://github.com/teambit/bit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f199998211654b688a0e5dac92d5153916b3efb79324bd5aa7eb3f03a620676" => :mojave
    sha256 "50637f1b4a01e7c571799e11235ef5d4b46c6f2c31319ccc6121f05cd780972c" => :high_sierra
    sha256 "e85849ea0f3bf7ea3a1ef9199a109a11c5a6fd4ea44cc86cd31fc1aa34dd423b" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"Library/Caches/Bit/config/config.json").write <<~EOS
      { "analytics_reporting": false, "error_reporting": false }
    EOS
    output = shell_output("#{bin}/bit init --skip-update")
    assert_match "successfully initialized", output
  end
end
