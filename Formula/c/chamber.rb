class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "67dd82fcc178d773e6425fa63c78adc022fb7cf9f7e262bea8c326f53d959504"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(?:-ci\d)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9acb3e0bb95a422d2070a3f3d2f153ae839183d63c5262fe54583a091d9011cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9acb3e0bb95a422d2070a3f3d2f153ae839183d63c5262fe54583a091d9011cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9acb3e0bb95a422d2070a3f3d2f153ae839183d63c5262fe54583a091d9011cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "90425b71524d4bd97684525ae0588fe0654f8427ffdad753b8cd63b4ecb6b37b"
    sha256 cellar: :any_skip_relocation, ventura:       "90425b71524d4bd97684525ae0588fe0654f8427ffdad753b8cd63b4ecb6b37b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf830841e4b790aa126602dd350c51b0e87b275b58904bc13651ee15bec19621"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    generate_completions_from_executable(bin/"chamber", "completion")
  end

  test do
    ENV["AWS_REGION"] = "us-east-1"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "Error: Failed to list store contents: operation error SSM", output

    assert_match version.to_s, shell_output("#{bin}/chamber version")
  end
end
