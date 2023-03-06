class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/0.5.2.tar.gz"
  sha256 "fe95e68924943cc5e8aa919b2be899cdf17a3978d8047374dbec03f73f5272d1"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02eacd364b5a31e5844dfe3d151c10d3f7c3c1992a81add1acd322949a3b739e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e94bb850a299b24e027224436d67ba2e2713f07fa5bbcef219e8cb91f456d899"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c41c30766254d848ed42f743a17cda39c08ec6631a9a0e0a6c85001a3d876f6"
    sha256 cellar: :any_skip_relocation, ventura:        "36f11fba9bb0ba5b1e47a11ada44c15290b2b3bdac1aaaeac555d320baf651d3"
    sha256 cellar: :any_skip_relocation, monterey:       "670fe15b84c2545ccc94d6b3a3fa56c5853c7e9605a113765b6ddc13f6abd3aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e2549014d028b0af27a89bc105be26180cea40df73b4d1a752a878d586d7f39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e6ead641b34b0fb8b3bbb1527a177c74580928ead0431c42247f4ad1316ed94"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin/"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end
