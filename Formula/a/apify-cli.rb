class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.21.7.tgz"
  sha256 "bc5e57ace3d23f5f3b0943be63da7d064f8b6f69b86c5fe91d531b51cf35684c"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ae581a2de5d04f71ed21bff741bab73f275def98521c4646589f394442e14d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ae581a2de5d04f71ed21bff741bab73f275def98521c4646589f394442e14d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ae581a2de5d04f71ed21bff741bab73f275def98521c4646589f394442e14d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "edc91262c7350a16c35917ac43cf9be41c5e869d828c65c57c58c63421943845"
    sha256 cellar: :any_skip_relocation, ventura:       "edc91262c7350a16c35917ac43cf9be41c5e869d828c65c57c58c63421943845"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd63568b6c772830d022c8b1cd47369e6aa6bf965dd4f3b3aea3cc795cd0a98c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd63568b6c772830d022c8b1cd47369e6aa6bf965dd4f3b3aea3cc795cd0a98c"
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
