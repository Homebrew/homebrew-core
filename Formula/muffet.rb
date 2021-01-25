class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.3.2.tar.gz"
  sha256 "ee69f8c256fed8d0e692a35a5b206e24b04a00f7d82e8d9a645c28cf7d9b3b20"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "69140cc1b455447e3d854ddf1f72bf111f16b1172bb6c6b252eb91bfd33ba9dc" => :big_sur
    sha256 "a4bc44ac5a226e09826145e99e3ff61ab2a131f7f47c6d9ac0538c36d23ff860" => :arm64_big_sur
    sha256 "81e67b81c6f1ee2eb044713f4731fd52675c8680b50e9f7bbf8c88a6c759f50a" => :catalina
    sha256 "8dd42b1d41d88aae4737aba6ad652449a3750e19b3ee633ebfe279289cd015a8" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "failed to fetch root page: lookup does.not.exist: no such host",
        shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1)

    system bin/"muffet", "https://httpbin.org/"
  end
end
