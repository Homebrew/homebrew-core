class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.5.0.tar.gz"
  sha256 "eb1b447f2d44bffce79e286757d4805f7fd02755de9263e86c797838f8c1e573"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90b12a72add79ac5783fcacf6e49369ecb32daa3cec6fbd430ec1edd7135e982"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "983aa4fb31f31d7f64adcc63ea8c2a7f23dcf8f53139337f15c94df7538990e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0549666cbc13b4467ec5bfd1c1cb450b15cf91de21a0097b4f34cda6205a9636"
    sha256 cellar: :any_skip_relocation, sonoma:        "140fc6387113faef3fd0edb165e90061399298c39d7ece7a627ad1bbea2d6958"
    sha256 cellar: :any_skip_relocation, ventura:       "51126956bf9118fbc21032c6d531f6b9e56dfbf6e9f3c5a14754cf7124b9b08d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "023900d228ff274c3aacf2a4183ca70627bca7d205605cff954767a7f0bbee94"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end
