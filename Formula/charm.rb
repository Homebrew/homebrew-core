class Charm < Formula
  desc "Tool for managing Juju Charms"
  homepage "https://github.com/juju/charmstore-client"
  url "https://github.com/juju/charmstore-client/archive/v2.5.2.tar.gz"
  sha256 "3dd52c9a463bc09bedb3a07eb0977711aec77611b9c0d7f40cd366a66aa2ca03"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f0cac05e7c2c0990fd6c186405a13c832ff84b47fb77c2928aab7c29548b670"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "406f7bc14f44bd5462dde85da36d37cf5218ba7db06f7e27121ca2cc504d4eb8"
    sha256 cellar: :any_skip_relocation, monterey:       "117bca978b5d65dc38f4e63d54ca0ef24f3b3e8cc808c97488854afb3a48a2ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c5e1f0af81ab86774fe87eb7c793c390386cc45b255348dc6467ad030f740d8"
    sha256 cellar: :any_skip_relocation, catalina:       "2cfca124d8f2bdc973797c2a290b36f87e4d8d4d39e7ebb4358b552e12ac89eb"
    sha256 cellar: :any_skip_relocation, mojave:         "a50370e9787fc797efc1b7c0dcc45fff5fd2ee02fea66e2d7db5d132c2153665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "623e2d62e1dc1210de466ff4e4ea1d8e0c8ea059dbdc491ff5b8f3ec1cc9603e"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/charm"
  end

  test do
    assert_match "show-plan           - show plan details", shell_output("#{bin}/charm 2>&1")

    assert_match "ERROR missing plan url", shell_output("#{bin}/charm show-plan 2>&1", 2)
  end
end
