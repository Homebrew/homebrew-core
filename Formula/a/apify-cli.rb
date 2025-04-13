class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.21.3.tgz"
  sha256 "1c8a3e93c8ada0985f612ef173742b5a524c792fbc563e1c8179c3abd9b55096"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed5db17096f5e734a3bdd35fa4eeb00296fa75570aa39b2683d315a883837ca7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed5db17096f5e734a3bdd35fa4eeb00296fa75570aa39b2683d315a883837ca7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed5db17096f5e734a3bdd35fa4eeb00296fa75570aa39b2683d315a883837ca7"
    sha256 cellar: :any_skip_relocation, sonoma:        "035450807712a495cad287da51f226f67188fc6ea3427bc817f28598ee686e4c"
    sha256 cellar: :any_skip_relocation, ventura:       "035450807712a495cad287da51f226f67188fc6ea3427bc817f28598ee686e4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6320376afc731b3353acea94a163af53dda8f2ada758272f9138565ca3ad5a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6320376afc731b3353acea94a163af53dda8f2ada758272f9138565ca3ad5a7b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_path_exists testpath/"storage/key_value_stores/default/INPUT.json"

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end
