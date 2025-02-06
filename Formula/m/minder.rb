class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://mindersec.github.io/"
  url "https://github.com/mindersec/minder/archive/refs/tags/v0.0.83.tar.gz"
  sha256 "ec21fc15911651f31853ce166098955b0116d50221e3749221a2e27b1781fd07"
  license "Apache-2.0"
  head "https://github.com/mindersec/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "604f3d1cdf02a927430e85db0e1baf7686b9376189dfe50b7ff9b8d77252ece3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "604f3d1cdf02a927430e85db0e1baf7686b9376189dfe50b7ff9b8d77252ece3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "604f3d1cdf02a927430e85db0e1baf7686b9376189dfe50b7ff9b8d77252ece3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf7aa8e3f973fedc604b021d1bbda2ee108a6aeb6f66cdadc32c7e7d96b55d57"
    sha256 cellar: :any_skip_relocation, ventura:       "c6baae551b4a42670210e08457e890e315162dc1ccc24fbcaa91a63face08fcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80700047f370338ba22aedccc36607d11284b85319ef9472a1104497c29c8549"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mindersec/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
