class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https://github.com/mbrt/gmailctl"
  url "https://github.com/mbrt/gmailctl/archive/v0.7.0.tar.gz"
  sha256 "8c3d88c06709d4c96414fa0ba1a90f0f8f12026d726a1ddb54b439b4b5b6ec5f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3a358debf1f7335f2736a28437b8106f917a9449593a498ccf6ce2589d813aa" => :catalina
    sha256 "7695c67ce6a12008b8c04a84d4899cf17d7bc5d3ad32a9bca35c101c1ca65195" => :mojave
    sha256 "c2803a3f282d5b1b60b76552787d13ad54d0403537380daebdf09105793b87df" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", *std_go_args, "cmd/gmailctl/main.go"
  end

  test do
    assert_includes shell_output("#{bin}/gmailctl init"), "The credentials are not initialized"
  end
end
