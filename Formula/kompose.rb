class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.27.0.tar.gz"
  sha256 "258e05c6e725fd2ef710275a6ce8d391d5d54de46f0a9f637ebbeb96b976b4ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c72e214d68b500682945ff6d24e363bfeeb5686fd8a1c165743f7f84c7a6b519"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73286744b877e3da7becc95f0502833e06eb37c36057c5719d00bb68901716f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ba5b4cd7d937e38071767bfef36948f1bd0786b607e150feab27d56e06d1e55"
    sha256 cellar: :any_skip_relocation, ventura:        "b68ba2aae5888ec75ec9cbeb112e1edf9976ca0b361eb071eafb3409c5148e8d"
    sha256 cellar: :any_skip_relocation, monterey:       "1b1d5018ace1b8247f3dd0474eb9632d011f38716afce6e74bdc30a402aa0402"
    sha256 cellar: :any_skip_relocation, big_sur:        "be28041f3dd15d9b717c0615c4234a3c615ce01baf423046f3b23f5f090a7412"
    sha256 cellar: :any_skip_relocation, catalina:       "b217de5792e76e969ce916c4e282f603751b69890d91a42f758cb4146a858566"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9b48d58808855c3e8aa8c4211422706693adbac6d416abfcb407e44d537188a"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kompose", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
