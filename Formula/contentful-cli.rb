require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.9.25.tgz"
  sha256 "731b37bbd974e5d1ef522479533e9e4940247b42c41deb1b1bbd1af0d225c3cd"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "60fbf0d48494987eb8f442c487778cf3e19fc92a9eff9e4c52cfd7df52991178"
    sha256 cellar: :any_skip_relocation, big_sur:       "380b071eaf5285cfd727c479434ecc2dd9ea12e8920246a04c5c3015540d459d"
    sha256 cellar: :any_skip_relocation, catalina:      "380b071eaf5285cfd727c479434ecc2dd9ea12e8920246a04c5c3015540d459d"
    sha256 cellar: :any_skip_relocation, mojave:        "380b071eaf5285cfd727c479434ecc2dd9ea12e8920246a04c5c3015540d459d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba7ef07df5e429d08dc16be2ad917b8e7e0c1ba1b81ef54b117eea01a86213b3"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
