require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.16.tgz"
  sha256 "db7f158f2b98839c5aa415cf9039fa7f7a95c5df1fea16ba16628aad097df74a"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7596fd74b47003fe9811eaf8a63beac500eb04b260e7f482f74dadde709c90ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec9d51b34b3f36607aa01adb911910a4e16d1af500c42a3c582ad3fd2e33a01d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec9d51b34b3f36607aa01adb911910a4e16d1af500c42a3c582ad3fd2e33a01d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec9d51b34b3f36607aa01adb911910a4e16d1af500c42a3c582ad3fd2e33a01d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c93e1b94bda1bf81dc6c6c798d1a4438c77b5995fa10a42e0501fea4d4b5b473"
    sha256 cellar: :any_skip_relocation, ventura:        "8ff9b7d5cb2f901019a2cbea27d3de7897cac1b2207c157570d2756b2e9e292e"
    sha256 cellar: :any_skip_relocation, monterey:       "ba499844bccbfc8cc4944e18d197165e5bea30e148072de119d14d54af0270fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba499844bccbfc8cc4944e18d197165e5bea30e148072de119d14d54af0270fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec9d51b34b3f36607aa01adb911910a4e16d1af500c42a3c582ad3fd2e33a01d"
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
