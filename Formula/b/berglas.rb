class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/refs/tags/v2.0.8.tar.gz"
  sha256 "1765994e212c0281b215aabae3ec95eef2894a6bfa99f5434db4bf6814c0c940"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/berglas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33f45ad747d7be2e840d6befa7de18a8f9fe1b71d1a7b707f68c454b8f87dd11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bacaef230bd9189cece3229c9ae695c9a38547e0cf7bcff8d38d993de445f437"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bacaef230bd9189cece3229c9ae695c9a38547e0cf7bcff8d38d993de445f437"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bacaef230bd9189cece3229c9ae695c9a38547e0cf7bcff8d38d993de445f437"
    sha256 cellar: :any_skip_relocation, sonoma:        "733fad7fc72998d03144ac96dac099243c32e6e92f1488eed016985f955b7010"
    sha256 cellar: :any_skip_relocation, ventura:       "733fad7fc72998d03144ac96dac099243c32e6e92f1488eed016985f955b7010"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0ebd830497e0a9496fb3ef987e6b75bebc16b7d868ee6cc31064738b53eb87f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "461226ff3f25d799795f5ab7d08f6552709219e27681c67d13eed28a06de1dde"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/GoogleCloudPlatform/berglas/v2/internal/version.name=berglas
      -X github.com/GoogleCloudPlatform/berglas/v2/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"berglas", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/berglas -v")

    out = shell_output("#{bin}/berglas list -l info homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
