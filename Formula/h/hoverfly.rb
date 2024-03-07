class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "cf8cdfdcb92f623a5c75c6ec91287ab921a3d4ef10b9bb2a838d82ffd3685716"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b9a4f999a13dfa66ac2d89d02160e5e1dcd0f3524744fc60cdc74224441113c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd5c74ed344ce09c1e5cf09d1e3553893c7d4a393f71ff427ab6e92bc518723a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73ad42d2aad5c499dafcee5bb4a4e07564a638fd202fbeca89595e7b0fd91239"
    sha256 cellar: :any_skip_relocation, sonoma:         "56aa4c5e50a1010a822ea2ebfe33ba6cd05db137acb82526c767f54a15e0435a"
    sha256 cellar: :any_skip_relocation, ventura:        "e678ebb024efdf0f7f24d44a006ce4e8904dba4d221fad03ff1a7c856a95e4c9"
    sha256 cellar: :any_skip_relocation, monterey:       "7fd135942c6e043825ded196eb36897c9c4cf029ac4e183fa7d85d84ae6cfae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "806ad4c3519bea33c96f99982ff6498afa389ca33514e9e8268c85fa8c166b91"
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
