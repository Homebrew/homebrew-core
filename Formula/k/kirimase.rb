class Kirimase < Formula
  desc "CLI for building full-stack Next.js apps"
  homepage "https://kirimase.dev/"
  url "https://registry.npmjs.org/kirimase/-/kirimase-0.0.62.tgz"
  sha256 "5d6d0e43b8bd07bcae71b279820491053b8a1445c5e6f8f66f5f0d158a67d16c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bb5a1ace88dffb207488229a4e1d18fc2b637154ce6f66604c2dfac5a8ef0ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bb5a1ace88dffb207488229a4e1d18fc2b637154ce6f66604c2dfac5a8ef0ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bb5a1ace88dffb207488229a4e1d18fc2b637154ce6f66604c2dfac5a8ef0ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "65d1f5094b1cee9827cad481203142f0529725823e5ea708b2881f49208f5a61"
    sha256 cellar: :any_skip_relocation, ventura:       "65d1f5094b1cee9827cad481203142f0529725823e5ea708b2881f49208f5a61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "247c4dabf7c49ec1076c4a160ce30520ae2bba151f82396df778e4bfb8ae581b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bb5a1ace88dffb207488229a4e1d18fc2b637154ce6f66604c2dfac5a8ef0ab"
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
