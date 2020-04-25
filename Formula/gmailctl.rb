class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https://github.com/mbrt/gmailctl"
  url "https://github.com/mbrt/gmailctl/archive/v0.7.0.tar.gz"
  sha256 "8c3d88c06709d4c96414fa0ba1a90f0f8f12026d726a1ddb54b439b4b5b6ec5f"

  bottle do
    cellar :any_skip_relocation
    sha256 "3db529f324e1e7394f7b22e6bb3dad49e95ff3da4d8fdd974a53cbee9d29225f" => :catalina
    sha256 "95376bd2e070749aa29e4f8e1e3a4a14ecd4aad551e213d25e7ba190f7bf6b3c" => :mojave
    sha256 "11bb0716e718f20777b086b826e1bd7b74ab953307e84b7a95f44ef8c8d72409" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", *std_go_args, "cmd/gmailctl/main.go"
  end

  test do
    assert_includes shell_output("#{bin}/gmailctl init"), "The credentials are not initialized"
  end
end
