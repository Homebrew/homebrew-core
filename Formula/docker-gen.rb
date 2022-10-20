class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/0.9.0.tar.gz"
  sha256 "9f270363d872e4d302b67b3baa3baec4d1c7b892814fd6a50e5953a2b90d745e"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f40cb72aa44346dd276d00f9587d27e7ccb060684d138e3045e0207b2b3cc325"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8edafbe63fac9db91d1202f54f59ef1c6cc3e65c3de3f7c9546943d297a0a8c"
    sha256 cellar: :any_skip_relocation, monterey:       "01164c6aa3f7a4aad182637b926a5c108154f115c5d1e3233d40237986fa8ce5"
    sha256 cellar: :any_skip_relocation, big_sur:        "1575d5f789387db751721f1114683e38c61f2519d07afcb82f214c13ce2434bb"
    sha256 cellar: :any_skip_relocation, catalina:       "47c4d2d964d487c1e45fdd9a4415fe5a1bff554f616eccc9e4a70930a205a752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e23c49eef1a172419af2bcaa3b35512401d45ad5d1b7e09e0d9e5af605230cf3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
