class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.327.tar.gz"
  sha256 "b8c8fbaf04dd35fefd973b7faf70dad40355f933af55f79d7f5147e299398b32"
  license "MIT"
  head "https://github.com/brevdev/brev-cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d671809d998944313dd8259767dcf2672d010e314e47f721341abee59a4b4d9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d671809d998944313dd8259767dcf2672d010e314e47f721341abee59a4b4d9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d671809d998944313dd8259767dcf2672d010e314e47f721341abee59a4b4d9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ce1dbae1ac2d65b7b4537f465dbe5ab41b008b0ca6aab6a0e11e5b442c1ef83"
    sha256 cellar: :any,                 arm64_linux:   "6068d40381ecedbd7a45fe37905fb3b96eb33ec5858139e5e56fd238d249895f"
    sha256 cellar: :any,                 x86_64_linux:  "fb768ece52335e8638f45b3b2d69150beb38cc92b397e60857b94f1eb1f1428c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", shell_parameter_format: :cobra)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
