class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "e54aedfdc17bee801b9804b517c2c699bfb764b3849e75681ac600476c9402d8"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65e7573969e090c7d1d6263684800c5e08c45c973d41294d4897e2eee1e93631"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65e7573969e090c7d1d6263684800c5e08c45c973d41294d4897e2eee1e93631"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65e7573969e090c7d1d6263684800c5e08c45c973d41294d4897e2eee1e93631"
    sha256 cellar: :any_skip_relocation, sonoma:        "54cd80011fe0307b8f63180f4e3d5dbf4b9034ca0225117d5d27a101e2ceb334"
    sha256 cellar: :any_skip_relocation, ventura:       "54cd80011fe0307b8f63180f4e3d5dbf4b9034ca0225117d5d27a101e2ceb334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c497cbe5d4bda7e5056aa257d4b63a84d883590249cd1619808b2e89a8ebbf0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"force")

    generate_completions_from_executable(bin/"force", "completion")
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
