class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.18.5.tar.gz"
  sha256 "fcf3d48d55c56b678b726826f8674d48bb739fd7a85a2ef20eec54947a3a0aa3"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e64b1cad8275e0b0f336d53979da017d77be5487c02dbebf02a4ec97693699c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a106271cb566e496365bcc6d85866846cdd9aa74ef0c4677d057270981c3f7a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e6ffbc9bc6348af782dd1be2e1e867263b883a309ec07358dc366dd2278bbee"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f150faae932effd21531bb73a8285ca0e94eb37a956fde8838ff8a991cb3570"
    sha256 cellar: :any_skip_relocation, ventura:       "e9d7a5e28e4519c6ab5f045387464c28fae6a20c72fdc2cb290a9d2dd57b3418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dd987c16b37fd31ced3eae4aa8c96ec1bff0e27079467c86677d8d39867a08f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
