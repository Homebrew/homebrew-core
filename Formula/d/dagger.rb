class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.13.5",
      revision: "dc83928c3a13d6b315bf0953befde001ec359238"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c73c2f2c7b06158d3212825821564933f4f5f200722d548110cd7537715f1ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c73c2f2c7b06158d3212825821564933f4f5f200722d548110cd7537715f1ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c73c2f2c7b06158d3212825821564933f4f5f200722d548110cd7537715f1ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "0021637565cfd1301e33be931b7674cd55a807baed4ad9a0f01d5d06ba7a78ae"
    sha256 cellar: :any_skip_relocation, ventura:       "0021637565cfd1301e33be931b7674cd55a807baed4ad9a0f01d5d06ba7a78ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53f2a82b82cf6673ff6be46af8e181ff2ce59f744b66d07a27bedc9380aa9c49"
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
