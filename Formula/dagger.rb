class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.4.1",
      revision: "2fb417e417d580362432a59af86415f0f8469a08"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b30b75d79ccef6b2109ec6aca1a98f667eaad242a76ed350201e40e873fea907"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43f26e9cc4fe8c7203c8c45f7ae3eaa06e28bbf1ea834f75c8c4c564ba61850b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9725aefe2e1a254edc04a05c93f9a309bdc1bd1e2de44e5b765b35068466f43"
    sha256 cellar: :any_skip_relocation, ventura:        "70a0d24e387c8d39ce7b0fb41936e708a72b812e15b012a552d06ddaa90f1bb1"
    sha256 cellar: :any_skip_relocation, monterey:       "0981de9a372e95781464b64cbd3a2b2967eec49c47aeabf436e2a7473c810e9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "156a031d51094eb28ad83e0b679bcb3b7eb1aa6c68818c6f4d756e2afa6a0b26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "137a0fed921bcb2a96d267f96e2caf288cefdb56b1d131ec3d2821b60df182a2"
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
