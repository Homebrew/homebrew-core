class Kubefwd < Formula
  desc "Bulk port forwarding Kubernetes services for local development"
  homepage "https://kubefwd.com"
  url "https://github.com/txn2/kubefwd/archive/refs/tags/v1.25.7.tar.gz"
  sha256 "733a6529df1508138c06ec46ba48eac8df6593e3c1fa2db8659452577f76f232"
  license "Apache-2.0"
  head "https://github.com/txn2/kubefwd.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubefwd"

    generate_completions_from_executable(bin/"kubefwd", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubefwd version")

    # Test that shell completion scripts are generated correctly
    assert_match "__start_kubefwd", shell_output("#{bin}/kubefwd completion bash")
    assert_match "#compdef kubefwd", shell_output("#{bin}/kubefwd completion zsh")
  end
end
