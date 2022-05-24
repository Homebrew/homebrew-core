class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.0.tar.gz"
  sha256 "fd73871e4f3023aa686788844280580aa49db38d949beb4499a7e364efd6cbf9"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bde52843a6f11100c8a3ecd98059b792ffb2e8fda0744fa745c455a6972f2848"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9f2280a977a73ec35b10e21641f75423e4bdc6ab84d816c2f2287b0672d86cf"
    sha256 cellar: :any_skip_relocation, monterey:       "0b3ce942f38abf3c9a4a3abfc7f7040f17991ea4f27063594c7b4f9227adb6df"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b3ce942f38abf3c9a4a3abfc7f7040f17991ea4f27063594c7b4f9227adb6df"
    sha256 cellar: :any_skip_relocation, catalina:       "ba0be1dcf29b89b52f35e8984621cddd64441e87873d380ccfeba13e53d0b80e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4145371c7c19df56712d0908f46a85067f8b5f602344f18dbbfb55ed17cf2d48"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
