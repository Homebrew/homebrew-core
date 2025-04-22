class Dish < Formula
  desc "Lightweight monitoring service that efficiently checks socket connections"
  homepage "https://github.com/thevxn/dish"
  url "https://github.com/thevxn/dish/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "31b3a04d43fe5fef3ba753ede5e2484d0ca01806ea19819a3d349ec102067295"
  license "MIT"
  head "https://github.com/thevxn/dish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d25c8c7528a83c822fee959c1f96e19fa2046d5504f947deb0f47cd1f4c42bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d25c8c7528a83c822fee959c1f96e19fa2046d5504f947deb0f47cd1f4c42bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d25c8c7528a83c822fee959c1f96e19fa2046d5504f947deb0f47cd1f4c42bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "72e5b5e1221c875430f1f223cf67eee61cd510e4c118a015689e5a59f292f6b2"
    sha256 cellar: :any_skip_relocation, ventura:       "72e5b5e1221c875430f1f223cf67eee61cd510e4c118a015689e5a59f292f6b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eada0861871db7ef90b354073c67436c08047b230ced37ae3c5a782e31da635f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dish"
  end

  test do
    ouput = shell_output("#{bin}/dish https://example.com/:instance 2>&1")
    assert_match "error loading socket list: failed to fetch sockets from remote source", ouput
  end
end
