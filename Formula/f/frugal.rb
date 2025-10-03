class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/refs/tags/v3.17.13.tar.gz"
  sha256 "3e55ad273b96bfc802beffe51ad694ce7b305a33a50c05efb1dfcf0bb4c7715f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eacd34e93b0fc193380d03bc05a347ddad3fee930429b65ec0a90f87ddb44467"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eacd34e93b0fc193380d03bc05a347ddad3fee930429b65ec0a90f87ddb44467"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eacd34e93b0fc193380d03bc05a347ddad3fee930429b65ec0a90f87ddb44467"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b40940a628e8ccc22ea537c97fbd9fe4fbe0d65767898429c26a50a88ad6b83"
    sha256 cellar: :any_skip_relocation, ventura:        "8b40940a628e8ccc22ea537c97fbd9fe4fbe0d65767898429c26a50a88ad6b83"
    sha256 cellar: :any_skip_relocation, monterey:       "8b40940a628e8ccc22ea537c97fbd9fe4fbe0d65767898429c26a50a88ad6b83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3181b74500e524d491a135703928e2681c01bd2052cd116565f34e0eab102f6"
  end

  # Also repository was removed and no mirrors available of tarball
  deprecate! date: "2024-07-02", because: :does_not_build
  disable! date: "2025-07-02", because: :does_not_build

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system bin/"frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
