require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-8.12.0.tgz"
  sha256 "6144d3b9315d19d785cbcc4d1430a949927ee2112681d2df6cb6414b65bafdfe"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "181b2d131ad2075698cb88b8d996249b07be792f9058c288bbae997d1a921592"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "181b2d131ad2075698cb88b8d996249b07be792f9058c288bbae997d1a921592"
    sha256 cellar: :any_skip_relocation, monterey:       "c2d1457b173041d5cef758462f2f264113c56ae7ace46b87557e610b91c176f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2d1457b173041d5cef758462f2f264113c56ae7ace46b87557e610b91c176f0"
    sha256 cellar: :any_skip_relocation, catalina:       "c2d1457b173041d5cef758462f2f264113c56ae7ace46b87557e610b91c176f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd6a7113ed8a9edc22187aca9e31e9dbe8e938783770fef4d782b30aecfda358"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
