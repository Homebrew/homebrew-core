class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.18.9.tar.gz"
  sha256 "1325467374d5324c0e1a81f2019a71e1898f80e4ca4a07dee8bfafba560f7db9"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a91e7a8ffe7d2b9c145273c15bb1982f8db43e81d64603219c4f8484b9feab3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a91e7a8ffe7d2b9c145273c15bb1982f8db43e81d64603219c4f8484b9feab3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a91e7a8ffe7d2b9c145273c15bb1982f8db43e81d64603219c4f8484b9feab3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e48f6d4cfd8ab89b48534351953550090b880de0894a96b78132f79c7d4f5d8a"
    sha256 cellar: :any_skip_relocation, ventura:       "e48f6d4cfd8ab89b48534351953550090b880de0894a96b78132f79c7d4f5d8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0331a87377f3bf35534768fcf8720cd1eee00aab2f0437c62cb04792f738981d"
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
