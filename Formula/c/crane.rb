class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/refs/tags/v0.21.4.tar.gz"
  sha256 "1fbeec420957f9d0dd78a644acd0409cca4f8024d8a214aa6b8733578422e0a5"
  license "Apache-2.0"
  head "https://github.com/google/go-containerregistry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4137bae259df8f00303a63a4ad0b05c2a86c5a7c03ba228ed2a10fa192912cec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4137bae259df8f00303a63a4ad0b05c2a86c5a7c03ba228ed2a10fa192912cec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4137bae259df8f00303a63a4ad0b05c2a86c5a7c03ba228ed2a10fa192912cec"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcbfbaa0f7a5adef3e47d5aa3d23ba6704b6942f4cccb5869535b8e89d675cf8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41507f90871d5e7a8fc8b0fd92686ee366ae2b5ffebd8335d74255c3dfe0a11a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b986952cd58949927a7f7355e01c379a3e30820a9ba48fa9ba44bab18aa7abf"
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
