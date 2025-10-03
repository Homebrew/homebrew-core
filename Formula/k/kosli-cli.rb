class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.24.tar.gz"
  sha256 "f1a43cd56d2d22615aa1195df1199afd6c18e3603f51cc1d999a048aa3d62b3f"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98da5e4e8685539a220c465876af5df0a1902d3a63d896eb6e918ab2e92de64e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2fb8d2c890f44dc4cc20af42581c6b4af5f61a0d11ef4abaf4e55784bf347dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4316160d40a459fc6c9ac3f9a7845cfdf3d34eebbdb2e789fb8cf9472ce009c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8e804bcc5992baa34b9f37ea5ed616337fb3c814db25280d3711b120bf4d9c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9031614586f5710c3fae51c9e09766577f649c7f61b374040429adf314763a93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9bc0fa42944159e8144c6b81751e9074e403e22daaa6f845e2bf856c49af7b0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
