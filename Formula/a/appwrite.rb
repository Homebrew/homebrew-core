class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://github.com/appwrite/sdk-for-cli/archive/refs/tags/27.2.0.tar.gz"
  sha256 "b82ebb057ad81eaef278d579588e3717f24e710bd8f4e3f43a403e82c9f70e48"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "571281a9a404ad11e8973afc2aafe3a0d76c840a2f90d3939b3163269fb5b4fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "571281a9a404ad11e8973afc2aafe3a0d76c840a2f90d3939b3163269fb5b4fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "571281a9a404ad11e8973afc2aafe3a0d76c840a2f90d3939b3163269fb5b4fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ab87bf3639443dfdf6b5a9f64b578f615e43a2f9ae3f8e4d1420f84108afa64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bffccd38723b54ad149ec42e54a8d6da67cdced51c41326f4b774ae087b44f75"
    sha256 cellar: :any,                 x86_64_linux:  "5aa875abfd65a6ac9d3deaee57e6296d294a56c79cdf7263a57ad9b77e70a1ee"
  end

  depends_on "go" => :build

  def install
    # https://github.com/appwrite/sdk-for-cli/blob/4399a3321898f40cf982acbd4859d506c9d4d9f4/.goreleaser.yaml#L19-L22
    system "go", "mod", "tidy"
    system "go", "build", *std_go_args(ldflags: "-X github.com/appwrite/sdk-for-cli/internal/app.Version=#{version}")

    generate_completions_from_executable(bin/"appwrite", "completion")
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
