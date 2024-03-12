class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "d058a0749bfd8b8f7c61b9e2bccd0e3f4d76de30f4c71037e28fd0cb822ea7f3"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23473906c2e9bbd83fff9a96028b7febca0f14f88a71e8b0f4461e57af38c09b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "370565f23e37f67561bef80d572c2cf351fd69c7c2a888b56c93203f1f98b355"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a4a49d1c04a43b761e10fac4941be3c3561aae1dc503672e4bba5a600c8ea87"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e64016d11b237edcedef464f2769afb8d98c7dc3d9b853eb66c7bf274c5d056"
    sha256 cellar: :any_skip_relocation, ventura:        "de2208dc6b3c909d1b5a4735567865e5401077aebe51aaab44a0fe4c55df8d1c"
    sha256 cellar: :any_skip_relocation, monterey:       "17005ca45f1871e09c85ef88a3ed275866086bf414aaf3cffef6a8f4f29f28b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f4d2e8710e176a5669897d582b6a011521eae487f9e61fb47ed547175ff7b8c"
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
