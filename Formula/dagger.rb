class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.4.2",
      revision: "b8051d3fa73d932050d16863bd1205d68a85c663"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a677298e6bf6c7186d41d1ccfbf4812119242693492cab1e4f2a6d90702cdc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad4355362554290ebdad9c55648e03fbad7fe33490064c6b2136e22ef788e342"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce63b5b50dc52bfbc173a23804b48c41be8ff571c00d00035f8bdd7a83a022ac"
    sha256 cellar: :any_skip_relocation, ventura:        "498e89075896dd872051b2177d70cd832398724d09d18d63fea2116c3dc646cd"
    sha256 cellar: :any_skip_relocation, monterey:       "3f7ee6b2b4992c48e40e53c821a5341d43550978c0d9983794e179cea4d4c06b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ca5ed60c01c10a45c5fd71146ebd659657c6bc0c2d1992c7ee452dade47ea58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c4f8e25cb15b5a1595ff5930b4a84b1e27fc9d885220165eacf7a4a9ffc2acf"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/internal/engine.Version=v#{version}
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
