class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "cda68ed5f795d717d2debb4704739daad5f68fd3c2d1300b4c37160d05e1f5bb"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(?:-ci\d)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1134d316f305554bffad0c48d0448a62820996b9b5651529c6e867ab84bf0794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1134d316f305554bffad0c48d0448a62820996b9b5651529c6e867ab84bf0794"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1134d316f305554bffad0c48d0448a62820996b9b5651529c6e867ab84bf0794"
    sha256 cellar: :any_skip_relocation, sonoma:        "985fe2b9ffe12b1717cd95dbd1f9dc7fafc55b9ec16c0d7f11004592302d8b55"
    sha256 cellar: :any_skip_relocation, ventura:       "985fe2b9ffe12b1717cd95dbd1f9dc7fafc55b9ec16c0d7f11004592302d8b55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58cb6639b183193dbfa865a8730df0c10493c269efb13c6923715d71e8485119"
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
