class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https://github.com/mbrt/gmailctl"
  url "https://github.com/mbrt/gmailctl/archive/v0.8.0.tar.gz"
  sha256 "13aa443b50910546c5dc8987f3f1ed7d1138571d1d0a0199e18e02122d404044"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e72f9006fd0c10ef79ecd4c2f875d1ee984d6ee40a6a717894b29cae9d3324fb" => :big_sur
    sha256 "ca176f471c5358025d9fcdc158a732e9e64232e5c2f7aaab53efbbb846920e57" => :arm64_big_sur
    sha256 "e191cdefb1f75f799f610aeaadd454c27d3aa90527d3bbf69ee804ca5c94dfa8" => :catalina
    sha256 "57d9dc005423a078971fd79d5c2382c07f17b4536a445d571cef47d025d28ffb" => :mojave
  end

  depends_on "go" => :build

  # patch go.sum
  # remove in next release
  patch do
    url "https://github.com/chenrui333/gmailctl/commit/63504e4.patch?full_index=1"
    sha256 "e93ebc411b590c4966c115dfbf567271a77c51a4e3ae5b93fd114cf18ef4ecdd"
  end

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", *std_go_args, "cmd/gmailctl/main.go"
    pkgshare.install ["default-config.jsonnet", "gmailctl.libsonnet"]
  end

  test do
    cp pkgshare/"default-config.jsonnet", testpath
    cp pkgshare/"gmailctl.libsonnet", testpath

    assert_includes shell_output("#{bin}/gmailctl init --config #{testpath} 2>&1"),
      "The credentials are not initialized"
  end
end
