class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "663f4b808c10315f56a09b7c0a63e314ad79b16a07f950641330899db68c6075"
  license "Apache-2.0"
  head "https://github.com/google/go-containerregistry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b83007cc815313ad6732c19ab1c7c6138063efb31f68d9ad34b7131efc4dd105"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b83007cc815313ad6732c19ab1c7c6138063efb31f68d9ad34b7131efc4dd105"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b83007cc815313ad6732c19ab1c7c6138063efb31f68d9ad34b7131efc4dd105"
    sha256 cellar: :any_skip_relocation, sonoma:        "b42df32566b9d2c6770c232f280481f34ad323ddd5e4f414c23f5a87d9675f7f"
    sha256 cellar: :any_skip_relocation, ventura:       "b42df32566b9d2c6770c232f280481f34ad323ddd5e4f414c23f5a87d9675f7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73cf545d4c043bf2f38d693fca210207c02bf2088086473d69c0814a0d835ce8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/crane"

    generate_completions_from_executable(bin/"crane", "completion")
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
