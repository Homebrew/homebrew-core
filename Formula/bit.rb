require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.4.1.tgz"
  sha256 "e19ab80681fa45c36b26837303ac197a80829553397a6ee6c4ace2caa964f81a"
  head "https://github.com/teambit/bit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d66411238cf960ddaaa1fc3aab044b053ce47a1c70d28ccc5fa8aa2496a6678f" => :catalina
    sha256 "0dd296196618b4e3ec8c51723d75902af3c862c84def53f40e6f4ea8d46d8035" => :mojave
    sha256 "ea1c445300eb59dfdace1affe09dd1301e01d46c9a43aae32064df1d0b8ea07f" => :high_sierra
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
