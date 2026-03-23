class Kubespy < Formula
  desc "Tools for observing Kubernetes resources in realtime"
  homepage "https://github.com/pulumi/kubespy"
  url "https://github.com/pulumi/kubespy/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "1975bf0a0aeb03e69c42ac626c16cd404610226cc5f50fab96d611d9eb6a6d29"
  license "Apache-2.0"
  head "https://github.com/pulumi/kubespy.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "029feef7bf428cc4b613f95bdbd189e7277d400cb6f54165933dddbcb04be245"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c37522a8957c50550223fb4b2328c1898e03ac58b396b4a29935bfa0ba117ad0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ddb3fd9926acbd341443c5cba25eadb6033a63777be75c8ffd8634bf4d1d976"
    sha256 cellar: :any_skip_relocation, sonoma:        "624ad6a1151a4771a25cfea3900ca0292ce77d97aa2da129cc7e9c9db2733513"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f43edfd8aafe2b5519b54c17e7028b53b365c29f5543b6af289ea84da49749d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f904a862816e12c913d12694bcfe8dab2bd6735704c2a33f75267e9888452f45"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pulumi/kubespy/version.Version=#{version}")

    generate_completions_from_executable(bin/"kubespy", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubespy version")

    assert_match "invalid configuration: no configuration has been provided",
                 shell_output("#{bin}/kubespy status v1 Pod nginx 2>&1", 1)
  end
end
