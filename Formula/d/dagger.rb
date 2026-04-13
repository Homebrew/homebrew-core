class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.20.5.tar.gz"
  sha256 "08c2a554cb36a335fbcb1d77be18a77892c3f4267a9e7d8aee895fb48c400768"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f42e45759d0ed4767a30b9513ce658a4c36c42127b5ebabcdd912007de881d84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f42e45759d0ed4767a30b9513ce658a4c36c42127b5ebabcdd912007de881d84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f42e45759d0ed4767a30b9513ce658a4c36c42127b5ebabcdd912007de881d84"
    sha256 cellar: :any_skip_relocation, sonoma:        "51ee2837a81ac22beff7a587631dc9470dc8d7df443569189486e2a9d0354313"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "828a9819f77d50e35145ea7ac5b6a750a335e99dc75c763acb380b110c059191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0db982f470681c31306c7f293c951321c3ff2b0a24cf60296c5fa59be006178a"
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
