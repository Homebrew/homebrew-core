require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.0.2.tgz"
  sha256 "921a530be7ac30fa1cfa3a12ae57a7ce12ab06338e7c9260f876fd5d1230717f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "84d27adb41111d1998c727872d52bfa1e69675834b5cddeb52a031234f16adb7"
    sha256 cellar: :any,                 arm64_ventura:  "84d27adb41111d1998c727872d52bfa1e69675834b5cddeb52a031234f16adb7"
    sha256 cellar: :any,                 arm64_monterey: "84d27adb41111d1998c727872d52bfa1e69675834b5cddeb52a031234f16adb7"
    sha256 cellar: :any,                 sonoma:         "c1a36cfdfb876cc0aeb92764e212f575cb81a54bdb597de95729136a886d2710"
    sha256 cellar: :any,                 ventura:        "c1a36cfdfb876cc0aeb92764e212f575cb81a54bdb597de95729136a886d2710"
    sha256 cellar: :any,                 monterey:       "c1a36cfdfb876cc0aeb92764e212f575cb81a54bdb597de95729136a886d2710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d85e0be5c034f656a90dea834647f32ec2bca148287d7b513e1de9c6436f1bb5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
