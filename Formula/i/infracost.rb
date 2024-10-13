class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/refs/tags/v0.10.39.tar.gz"
  sha256 "9d32bdbc0fee88d327046cbd39c3fd8f2991a06f571b1f416d429849f5dfc985"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d1ce1d05300f648e8114e305b13ff0d2fb8fe6feb71efbee9b6ca13076045fe2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e5b7bb2c8c23eb174f992a15617eb71b9b1e044d534a0b83ca968e7e74b46d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e5b7bb2c8c23eb174f992a15617eb71b9b1e044d534a0b83ca968e7e74b46d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e5b7bb2c8c23eb174f992a15617eb71b9b1e044d534a0b83ca968e7e74b46d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a6c1bd7aea6b16319927a68d82b504221158f1256c1b44e2fead2876df8684a"
    sha256 cellar: :any_skip_relocation, ventura:        "6a6c1bd7aea6b16319927a68d82b504221158f1256c1b44e2fead2876df8684a"
    sha256 cellar: :any_skip_relocation, monterey:       "6a6c1bd7aea6b16319927a68d82b504221158f1256c1b44e2fead2876df8684a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebc9949d99eb8d599e1b3013862e041f682fb90e0e3f80e32200e3ec387ff4a5"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/infracost"

    generate_completions_from_executable(bin/"infracost", "completion", "--shell")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "Error: INFRACOST_API_KEY is not set but is required", output
  end
end
