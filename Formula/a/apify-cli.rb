class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.21.1.tgz"
  sha256 "bb7db120ca479aecdd7a5067ac178a4b58c346980a2b995ddaefe8567b23b5da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ea72f490602da1af90ea50acf2f45241eb4cd098ff3e32c53df3e897046a9eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ea72f490602da1af90ea50acf2f45241eb4cd098ff3e32c53df3e897046a9eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ea72f490602da1af90ea50acf2f45241eb4cd098ff3e32c53df3e897046a9eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "55a3deb83653f73171bc91b2a8092e1164e5d004099ad9737b9900e2f46d489e"
    sha256 cellar: :any_skip_relocation, ventura:       "55a3deb83653f73171bc91b2a8092e1164e5d004099ad9737b9900e2f46d489e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78201e517d5fa80a2cc91e68cf6494f0d4455da288fbed38295a9a92451d4c25"
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
