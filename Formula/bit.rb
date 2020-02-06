require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.7.4.tgz"
  sha256 "4cb20d2db9836706dacc56cce8839adcee2a25739d912fee25b27a77b77fbc46"
  head "https://github.com/teambit/bit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2d93dbe7b2b2c8e30934ed52b77414d19cccc2a32a2b90d514df66e304231d3" => :catalina
    sha256 "25f1ac81b06cf80caa4d32a92493406fbe966dd436deec5f4ed8343d5738eff8" => :mojave
    sha256 "ae63237ca27a8b5bb87dfa7bb3f050bf41ddbb311c22545eeeb57659abbfca85" => :high_sierra
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
