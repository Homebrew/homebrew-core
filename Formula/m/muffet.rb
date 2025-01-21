class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/refs/tags/v2.10.7.tar.gz"
  sha256 "b278d9aad33f77c4eb48b761592f3220a05c2f692b54ce27245d0e04c5ad095c"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2065a6c0186ffda9fff18085b5c622e723d49769396d1a01289e1d9e5c4176a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2065a6c0186ffda9fff18085b5c622e723d49769396d1a01289e1d9e5c4176a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2065a6c0186ffda9fff18085b5c622e723d49769396d1a01289e1d9e5c4176a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e91e049274c923f00da03d29622b6a1236b601100e2b5b771b33d3281f282c6"
    sha256 cellar: :any_skip_relocation, ventura:       "5e91e049274c923f00da03d29622b6a1236b601100e2b5b771b33d3281f282c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8355f387677d8564a9fe4821572f6c99e76fa33f9a9a291796f049eb0b78f59e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://example.com/",
                 shell_output("#{bin}/muffet https://example.com 2>&1", 1)
  end
end
