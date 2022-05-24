class Mbw < Formula
  desc "Memory Bandwidth Benchmark"
  homepage "https://github.com/raas/mbw/"
  url "https://github.com/raas/mbw/archive/refs/tags/v1.5.tar.gz"
  sha256 "3c396ce09bb78c895e4d45e99b1ae07f80e3ea5eee59d78ed2048a7f2ae591ae"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb3f19dae68400aeca4d6c7c8f3498c0a50c20cbfe3d6db4ce170f890c99c0f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bdecad6854dc81fea65dd87d0f4fe137e7b5108ba5863987220026cf7930194"
    sha256 cellar: :any_skip_relocation, monterey:       "beefccd2c0589e3fcb8abb2460871cc5a032ba16d36f3ae7e2112c0b69b69a48"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a777bd097548852a2ce0d30a05698ff01f59e41b1f036d88f063891bad79cd7"
    sha256 cellar: :any_skip_relocation, catalina:       "43c11abe8ec4602f220dbf9a7142564a9cb619f93e454811c4d9845a33054649"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b99cadb3aba3da2c9487c872eb613fb5b64cdb7ce9c910a2951d9e36967082f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "AVG\tMethod: MEMCPY\tElapsed", pipe_output("#{bin}/mbw 8", 0)
  end
end
