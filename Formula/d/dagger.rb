class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.20.7.tar.gz"
  sha256 "99f4bcdf4339c42372190bba78297da20cda5509ba74f43872d47be37045c234"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4152c4e1fe8f5a2ec387d053c4710f8f2272efb3573c7923fb3e202d66e6669a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4152c4e1fe8f5a2ec387d053c4710f8f2272efb3573c7923fb3e202d66e6669a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4152c4e1fe8f5a2ec387d053c4710f8f2272efb3573c7923fb3e202d66e6669a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e76b9351d5d0a002680ccae440ce352d3af82dbcd4c6d70892a5ee00c450de4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "068915a724ce5e36115ccec2ded69c612b5521ca8e4116b708dcce11ecf4105f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1ae98fc364a8a987b60c456dd05c490aed514aab8692da66582501aa8e5da5b"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "failed to connect to the docker API", output
  end
end
