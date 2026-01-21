class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://ko.build"
  url "https://github.com/ko-build/ko/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "1006eb94b6260690ab3ec79cbd03342e09cb0f32cecdd1b8743fa216e2fe7b0e"
  license "Apache-2.0"
  head "https://github.com/ko-build/ko.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bde2f0196739939b8d40c71a749f703663511d505757d0c037d47a4452aa3e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bde2f0196739939b8d40c71a749f703663511d505757d0c037d47a4452aa3e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bde2f0196739939b8d40c71a749f703663511d505757d0c037d47a4452aa3e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cbfa0acc43aa64e3f99f16c54fb117bddb6eda078de8b411d8815115b90233f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b17a62d65df38d8e704d192a17fa800a56a487427cdbfb0c5b25e3f5f3ee544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d92244e21a8a0f4f080d93831ad9f873809aeb50f5308fa9e19667de080978c"
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
