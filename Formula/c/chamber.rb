class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/refs/tags/v3.1.4.tar.gz"
  sha256 "89226bd14752fc36a2032ba1b102b3dd223d9372cee01fdd7c6d7df1518b025a"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(?:-ci\d)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a251cb1b99832b9eec10b765fed82c32303eea069f305a1371ba6b73613788b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a251cb1b99832b9eec10b765fed82c32303eea069f305a1371ba6b73613788b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a251cb1b99832b9eec10b765fed82c32303eea069f305a1371ba6b73613788b"
    sha256 cellar: :any_skip_relocation, sonoma:        "19cc9283f7d59ae241ea1970b4f2d5e227952ca4f4b391bee3c0bd2636f84b14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88de458a5bfc02c14c1da9b1b910b5f4b400bf60ea71b9caf2fb164850690435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aa56437ba101da8306b53675aed5080d8caf3a7379fabfce44292de93cc7ef9"
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
