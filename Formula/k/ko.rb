class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://ko.build"
  url "https://github.com/ko-build/ko/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "7accc1f4ad074285086573b084387bef5871872ef16e3f292d5818a99e4feeae"
  license "Apache-2.0"
  head "https://github.com/ko-build/ko.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbde500ed751d4ff2c9e31c0253631653b527187d1dc6814a3d6f78d8eb38f90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbde500ed751d4ff2c9e31c0253631653b527187d1dc6814a3d6f78d8eb38f90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbde500ed751d4ff2c9e31c0253631653b527187d1dc6814a3d6f78d8eb38f90"
    sha256 cellar: :any_skip_relocation, sonoma:        "daed15d71cb650df58ab5d6aa8e3ee6a48499ac31560f3d3121bc3bea71d175d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3410988c67cb735edf75c617eb58a84970af090b22f9a0c305db2094fcb271a5"
    sha256 cellar: :any,                 x86_64_linux:  "bde47c117e53e1b8fe0a955f83e07b77023f6b454366a64addc7f0a47cbff0a9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}")

    generate_completions_from_executable(bin/"ko", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output
  end
end
