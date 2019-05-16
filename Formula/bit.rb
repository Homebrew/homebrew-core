require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.1.1.tgz"
  sha256 "2d8f674a47b0f44f043a4865c90ba9eca41dff79e3742a2a3de5c244350147d4"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "f889058e6d163c732bf6697f40f05dd2b2dd736e3ee9c32b9590bab37fd0edf9" => :mojave
    sha256 "7b5f8b38199dc166b680c2e482c135cc22d9f32af816e50c47d7bff2f6c7e443" => :high_sierra
    sha256 "49e6c7a5c40fcd6258915f9ef45bff6aed7d9679f0e722e290917b2fa3f01dae" => :sierra
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
