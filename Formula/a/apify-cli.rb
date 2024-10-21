class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.20.10.tgz"
  sha256 "fc5ed83073717d3e0040363cbf92d77443b765ac0b302a8cba7701d5a015e8d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42ee2c893cc25fd90ab5d82d3efff743c307852fea387e1544e11e6570226ae6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42ee2c893cc25fd90ab5d82d3efff743c307852fea387e1544e11e6570226ae6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42ee2c893cc25fd90ab5d82d3efff743c307852fea387e1544e11e6570226ae6"
    sha256 cellar: :any_skip_relocation, sonoma:        "656fe898117a0f1330f7ef868f082ed93249f976c194f09caf63ecd84bdf9f8f"
    sha256 cellar: :any_skip_relocation, ventura:       "656fe898117a0f1330f7ef868f082ed93249f976c194f09caf63ecd84bdf9f8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1be3f81a0721332957f51ec3073844ab121c85d82788a23476c2993842d44351"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_predicate testpath/"storage/key_value_stores/default/INPUT.json", :exist?

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end
