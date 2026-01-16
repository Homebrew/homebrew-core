class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.19.10.tar.gz"
  sha256 "8e4e8eb13d84bd3ef054b3058e7a53af51286a5f8bfcff28438acd9bd9bb8ab6"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29097e581cbf7b96acfcd5b9964ae2f2b148fa602d2647a249b2deceb7c63482"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29097e581cbf7b96acfcd5b9964ae2f2b148fa602d2647a249b2deceb7c63482"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29097e581cbf7b96acfcd5b9964ae2f2b148fa602d2647a249b2deceb7c63482"
    sha256 cellar: :any_skip_relocation, sonoma:        "0766582b9cf7cebac82788370218bedec39736968276d98036c2722be8c6dcb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d2d43434db976e75c3b4ef5eb25e6788161427886ee9d4c1e293bbcc76438a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a573f1beb6062b80ba694b791685386636865e28d9d107f0d6b939b9e33b4c25"
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
