class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.20.3.tgz"
  sha256 "475252be968ede54a1bc58143b58d47d7c364f6cc21f416b18b2d8ac3dba9ee0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52d09bbeb434c1b9b9dcfa21d9d3d7ccaa2f1b8629c4d581cf122f5eb64c2766"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52d09bbeb434c1b9b9dcfa21d9d3d7ccaa2f1b8629c4d581cf122f5eb64c2766"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52d09bbeb434c1b9b9dcfa21d9d3d7ccaa2f1b8629c4d581cf122f5eb64c2766"
    sha256 cellar: :any_skip_relocation, sonoma:         "63b3ae5a1d64ef264a2dc19bde6ec273d9b43c535a5e0ec1027a3939c0f13624"
    sha256 cellar: :any_skip_relocation, ventura:        "63b3ae5a1d64ef264a2dc19bde6ec273d9b43c535a5e0ec1027a3939c0f13624"
    sha256 cellar: :any_skip_relocation, monterey:       "63b3ae5a1d64ef264a2dc19bde6ec273d9b43c535a5e0ec1027a3939c0f13624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6f22a32c25bca28aacb7e15a8892956f4fc23e1eafae87e031ea55a984a79e8"
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
