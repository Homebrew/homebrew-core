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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5337bd1bd08714a29659e6d96e9e5c7fe8fb1588699673f9bcb3bbe92093f2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5337bd1bd08714a29659e6d96e9e5c7fe8fb1588699673f9bcb3bbe92093f2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5337bd1bd08714a29659e6d96e9e5c7fe8fb1588699673f9bcb3bbe92093f2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1272a1b240390595c0334614deb8896d1398889673f061c83b52549ced6ef3b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cbb3e3a701c9f6b4ace172f74d865255d7e1b6aa6f8e274275a877f6d754f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69d7da496e18074c011af273f90fc95ccdc4aba35c14132f175090a01cfefd70"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    generate_completions_from_executable(bin/"chamber", shell_parameter_format: :cobra)
  end

  test do
    ENV["AWS_REGION"] = "us-east-1"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "Error: Failed to list store contents: operation error SSM", output

    assert_match version.to_s, shell_output("#{bin}/chamber version")
  end
end
