class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.39.1.tar.gz"
  sha256 "38ab86dd3dfd2f882af4c10d72c6b903a006daee30c135da0ec7bd34d2558047"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c46365491070e9dfbc14bacab99458ec4a4b015f3f521b476c07f8e74193432"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c46365491070e9dfbc14bacab99458ec4a4b015f3f521b476c07f8e74193432"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c46365491070e9dfbc14bacab99458ec4a4b015f3f521b476c07f8e74193432"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ba50b2fbefaf13770e9c63a87f48f59f66c67fd941a0e9f73a7e6f61e92a0fc"
    sha256 cellar: :any_skip_relocation, ventura:       "2ba50b2fbefaf13770e9c63a87f48f59f66c67fd941a0e9f73a7e6f61e92a0fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0d018ab191df66f85b306ee5b70f90333604757d100c46c4f901fface3728ec"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end
