require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-20.0.2.tgz"
  sha256 "7ec01246c8291cd6194587e4fe0eba92a554336ec2342a74c9eb47cf1b41179c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a43ebb35b0f50e56e1638f574d8441f136c7d20edf2577af74f82c40ee5b848"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e522dbb7488486df84ec40dba10a30b61fabe933c3ded8afb4e8fcf9a241b72"
    sha256 cellar: :any_skip_relocation, monterey:       "4fa733e58cea7fe7ecad39dbc27200553562dc44c57cbdcccec6e3eaf7c0a5c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6eb8a939cd58bb967b81d2b19a9754269016fb6c517ebfe5a45cecff33f9f72f"
    sha256 cellar: :any_skip_relocation, catalina:       "e3af18a1b48a38407825a2d3ffe3bf60ecd9ac37b7762d3cdcb0ebbad29d7c9c"
    sha256 cellar: :any_skip_relocation, mojave:         "df7a7fd00f429e4db18d0efe676f9ed081efc4175dccb0f59c20e97b87e1bb0a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "be1769bcf8dea3bd6db0237948e500334a6813fbfbab34c90eedbbe9518df838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91533eff62e86951a9b67f7d9ced7673627add44ac66320199f8336b6fc576ad"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "bar", shell_output("echo '{\"foo\": \"bar\"}' #{bin}/fx .foo")
  end
end
