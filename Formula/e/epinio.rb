class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.13.8.tar.gz"
  sha256 "8e9d9ef6a68f01d9db6b5cdea8d8f87e9809c995818580cff87e60fc3a44b4c0"
  license "Apache-2.0"

  # Upstream creates a stable version tag ahead of release but a version isn't
  # considered released until they create the GitHub release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "631eae6549319558ae0cb9d2f8431d75288d631f0ff0c9ee120f12abee7bc8ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee059124aa9e92d99b864c1835ea607940f767dc16ef814915b4c3a923fc17c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92efb403b063fef71776c2dd569d460cda70750501959dbb32260ac474b3dcd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ae57061d3a8f4d98dde127e12dfe9aa5f706248b93a23408cc1cbfad86ecfba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63abae1d38002e212785d2c7531dd1f2a19ba07b22dc9c8796ff0ff4e3fa282e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c12e107509ae925e60fcc6104789dea757dcf30d262b58d42128805af2d4c2a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=v#{version}")

    generate_completions_from_executable(bin/"epinio", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: v#{version}", output

    output = shell_output("#{bin}/epinio settings show 2>&1")
    assert_match "Show Settings", output
  end
end
