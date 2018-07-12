require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-13.0.3.tgz"
  sha256 "8534253c8b56f3a1ed381f088f42a86cd9ffaaac4eda00805193eef863f66226"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "2b3ad9e2e984812fc1276a6980fd2d69a0459d5e616e235a48761845e7e3e023" => :high_sierra
    sha256 "9ecdcbdc78411416b727f73195a3798bdb91358dd366fc79bb1790def7756af4" => :sierra
    sha256 "a26c6470220bed99516601f9486dd88d1e58ca30964c1b0d1a7b5c312bab5df2" => :el_capitan
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
