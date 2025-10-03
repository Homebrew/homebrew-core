class Kirimase < Formula
  desc "CLI for building full-stack Next.js apps"
  homepage "https://kirimase.dev/"
  url "https://registry.npmjs.org/kirimase/-/kirimase-0.0.62.tgz"
  sha256 "5d6d0e43b8bd07bcae71b279820491053b8a1445c5e6f8f66f5f0d158a67d16c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "576a94fbed2383917bc82e212abf02911902a14668878dbfb747743dda5aeaf6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kirimase --version")

    output = shell_output("#{bin}/kirimase init test-app 2>&1")
    assert_match "[fatal] No Next.js project detected", output
  end
end
