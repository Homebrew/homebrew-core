class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.6.0.tar.gz"
  sha256 "ce5eea62e9d130e3557c11016c306485ccd77919cf85d706a2556bce28d085ed"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9042c369628ba6ed7f01ed774114ed5194f2a06db3c91f6bd3baa958b387a52d" => :big_sur
    sha256 "73af9616980727010bb370b90f195acdf7fae8fe8aed870afa7059b37cbd6cf0" => :arm64_big_sur
    sha256 "1e9b569d40889982fc89ed2e6182e40c8d7151e4f696ea1d8ef8c49a7be9a71f" => :catalina
    sha256 "21c9319ca3d75ca69883c1df8cbdb504ddc307577f6e5aebd10ac2970655e4fe" => :mojave
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=0.0.0-dev", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=0.0.0-dev", output
  end
end
