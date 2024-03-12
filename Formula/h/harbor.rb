class Harbor < Formula
  desc "[Sandbox] Official Harbor CLI"
  homepage "https://github.com/goharbor/harbor-cli"
  url "https://github.com/goharbor/harbor-cli/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "8a764ea10173d8dca4c99c79f55b054bea184abf012e7a346b7b39fae094d805"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    
    ldflags = %W[
      -s -w
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/harbor"    
  end

end
