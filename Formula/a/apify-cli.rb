class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.21.0.tgz"
  sha256 "86509c008f2b732cdf7a2b3e2e6b16ad1082713a2bc671a7c487e7cd37af386d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcc403c4c3c3dd8564e225a9373e5fdb330d104adaabdee2c14feff5fef8cac8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcc403c4c3c3dd8564e225a9373e5fdb330d104adaabdee2c14feff5fef8cac8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bcc403c4c3c3dd8564e225a9373e5fdb330d104adaabdee2c14feff5fef8cac8"
    sha256 cellar: :any_skip_relocation, sonoma:        "48d3b915abccd9a25ee793b6def938c847eabc20445f1d2ae50e73e6f18cf193"
    sha256 cellar: :any_skip_relocation, ventura:       "48d3b915abccd9a25ee793b6def938c847eabc20445f1d2ae50e73e6f18cf193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1847a06be9af5548d3a98447136744d0750c777b80ec2e830a86cb95ae835a44"
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
