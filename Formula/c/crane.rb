class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/refs/tags/v0.21.3.tar.gz"
  sha256 "5043dc8f756fb1a4931c755a0615122ad355d155d07e385cccd736d046e77d0c"
  license "Apache-2.0"
  head "https://github.com/google/go-containerregistry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7990f976a09f5dd54f1a3713f2e984fc86f04fceda2a3de048ab0e5c749fdc89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7990f976a09f5dd54f1a3713f2e984fc86f04fceda2a3de048ab0e5c749fdc89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7990f976a09f5dd54f1a3713f2e984fc86f04fceda2a3de048ab0e5c749fdc89"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b2d934d41ee2ef7efbd60eed4be2cf6f58f7a627a472b0ff16537160b92f8fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90e21d9ffedadf86705f53ba4a7827d3f25a22d6e5deb7f67a4afbd20045040f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "972c8664c8e41a31682199b7c7e5a229758414a21c97e28e1cbfd09d4e05fe5c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/crane"

    generate_completions_from_executable(bin/"crane", shell_parameter_format: :cobra)
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
