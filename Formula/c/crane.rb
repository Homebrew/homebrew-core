class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "a52cc7d61f8b2f043b7f0be1febecead5fceb791543c4790d699440f12d6b370"
  license "Apache-2.0"
  head "https://github.com/google/go-containerregistry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52b52a75d91903ce0526e221a68b366f26ade0bf6cd6cedcc5907bcb2ad0c31e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52b52a75d91903ce0526e221a68b366f26ade0bf6cd6cedcc5907bcb2ad0c31e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52b52a75d91903ce0526e221a68b366f26ade0bf6cd6cedcc5907bcb2ad0c31e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e07ecca62971afe18487ee4baf56f355c4ce260ad5b7af7bdccdb789c534987"
    sha256 cellar: :any,                 x86_64_linux:  "d7a4c5af9ce9a22c91eb826e7de63caf79e3fd646119f396dea1cdac4599718d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}]

    system "go", "build", *std_go_args(ldflags:), "./cmd/crane"

    generate_completions_from_executable(bin/"crane", shell_parameter_format: :cobra)
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
