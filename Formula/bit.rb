require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.7.6.tgz"
  sha256 "4119252ff4943449682b6369b66677787723351748dadc7382ffab90768e6075"
  head "https://github.com/teambit/bit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e85663860cac5bccddf6ae49f6952e7d026e0e50af24c1d130d964b2c6faae1" => :catalina
    sha256 "644e22002ebabdabf49e68f6456f4b7a3506f6496fb5c7aa108b442e6889140d" => :mojave
    sha256 "47b93bc393e53bbde7fdcdbad4bdf927563b5046b22b0588b2a614670c817338" => :high_sierra
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
