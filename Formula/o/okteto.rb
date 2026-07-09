class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.21.0.tar.gz"
  sha256 "1d2b32e8ee421eff2bd28c781427b15bfe8f4862b49b408469b10ee96ec3078a"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1eb9ad4eb53e246b47fb2732e8075b45d967b8c83dbdce63b9ad1f984bf5c702"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e75652af5a5677ae005ebb05e69b09d563f48152e54093b03db816d28cf49400"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33d5a974021a4c1bdab1390ee7c1eb57b5484fd32a8f3ce2a7108c63299b38cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebde170e074f4cc269bfdf5ec13d66483dd1798d981aa152a72cd6025fb18767"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfad6de686d306a5e4f00ee5444ffc92babbc22074dba7eab91982e7be250b85"
    sha256 cellar: :any,                 x86_64_linux:  "0e1c674a74df9f041e09015d107c72b0dfdf7ef9cd8ab3fa5e6adfbd053c2e9a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"okteto", shell_parameter_format: :cobra)
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end
