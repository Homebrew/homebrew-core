class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "5058e212954d4404fe43e28e0f781a012ad2658cb1dc94665bcf1cc7042a65a1"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1245ad328471ce907a67368fbff35593b77cfb537b01e29e975839404c9c7ee9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1245ad328471ce907a67368fbff35593b77cfb537b01e29e975839404c9c7ee9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1245ad328471ce907a67368fbff35593b77cfb537b01e29e975839404c9c7ee9"
    sha256 cellar: :any_skip_relocation, sonoma:        "836ee52fb6bb7435eb393312628375519dfe219a1b72c4b2d0c3dc67b4fd1d30"
    sha256 cellar: :any_skip_relocation, ventura:       "836ee52fb6bb7435eb393312628375519dfe219a1b72c4b2d0c3dc67b4fd1d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78a977a7ae0456bb8768c005aa3abc4568908d407b155157f9201b4e5912692f"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
