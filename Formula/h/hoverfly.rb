class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.12.10.tar.gz"
  sha256 "ad239aa0ea3e8a29e76c81740c29be4af7658a642e83fe1b44f085998ab04192"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82a09fc2630b986e841480258cc7710bac8e55477ca0e637ebf3b05925661c3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82a09fc2630b986e841480258cc7710bac8e55477ca0e637ebf3b05925661c3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82a09fc2630b986e841480258cc7710bac8e55477ca0e637ebf3b05925661c3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c292932fae3ec498366b1d34f188ca4af9817d8a987fdcd4c1a7430116f0899"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab977acd1c402114fabbc7aa870d8a3413e3489ab128cb4becd482df5b82937b"
    sha256 cellar: :any,                 x86_64_linux:  "20c9ec2b38153fb58b372f93a06d42931cb5e3eb7423dff010060cba882bbe57"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
