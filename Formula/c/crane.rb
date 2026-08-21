class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/refs/tags/v0.21.9.tar.gz"
  sha256 "6d8bce869afcc485b518cc0d59ea0ffe1090026db965806bc3be8793182528cc"
  license "Apache-2.0"
  head "https://github.com/google/go-containerregistry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da9debb8436aab46fea78f6853e4dc46d3cc5f7fa3ee24fba78a20a332e09dca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da9debb8436aab46fea78f6853e4dc46d3cc5f7fa3ee24fba78a20a332e09dca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da9debb8436aab46fea78f6853e4dc46d3cc5f7fa3ee24fba78a20a332e09dca"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2f6eeebed24749d9dfc177269456cc05db1d597d1f1f9bb8baa5fd2256c6b8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f65aec042a82b024d3b42bd81237e692b747a1afa700186cad7185670c15ee53"
    sha256 cellar: :any,                 x86_64_linux:  "4c172801cabf797c370af6a7f733f03ed5aa8945f98fbf4fb43ffaae3d21f790"
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
