class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.10.1",
      revision: "e04ce8a9bd8a865e0c1b86b272128cf8ffa0e62b"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "956b5b02cc58ec9a07200ee63d85997ec3a8544ef9a5ce25995a877a1fdf0bab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fc23597af7696f1b785a701574b4dbbb3152383cb472ab6dc86c362e4a20dfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4786407d0b4d796d924cdb5747c335dd211141453123cd8bdaa280c99914b3ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "093569ce7aafa46b51cccc8bcc2ed02358367d74ad90bf714330998247a4ae98"
    sha256 cellar: :any_skip_relocation, ventura:        "6075ce270a522bb8c5c81081dc441280c4de84ce88964757a7cbd4f0f6e13a60"
    sha256 cellar: :any_skip_relocation, monterey:       "768b332c8661a96bb2e5f3cbac5cd4cfbc2306ce39b4d3c363d157c922e36791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c93215ddbbe9489aa155c5557f413c80880ce91b3b5b3cf6a0d52f16052e971"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
