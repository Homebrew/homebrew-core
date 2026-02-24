class HolRegistry < Formula
  desc "CLI for searching, resolving, and chatting with HOL registry agents"
  homepage "https://github.com/hashgraph-online/registry-broker-skills"
  url "https://registry.npmjs.org/@hol-org/registry/-/registry-1.5.2.tgz"
  sha256 "094751f72a00bf9460e913776c7cc3d1823a75a6de342cdc13548c14cfa76c87"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/hol-registry --help")
    assert_match "HOL Registry CLI - Universal Agent Discovery & Chat", output
  end
end
