class Cozypkg < Formula
  desc "CLI for managing Cozystack packages"
  homepage "https://cozystack.io"
  url "https://github.com/cozystack/cozystack/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "a3cefa246bfb22c6bd77c1b422e5b641732856b51479aae5cfdfb07b2b212735"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozystack.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35a3164b46bf1feb96f6c8e3b6c082730846cd86c436a5e31efa2a6450f4e127"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "257f21a302a1e59aa85e92a06642464ceb593dd84876f8e5681f4994ced0254c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35045f851ac398f02cedc21a9bcd4ad682c9f704ee71bc3b1060a32d8f0c26b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "acf1f6de60a9c38434937dd3dcc18dd4141a976e0663ecebb62aa67fbefa49f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33820e875a9a3447b8efa24fe1f5fc0704e99bc1ada500a40e36fbda3c04d959"
    sha256 cellar: :any,                 x86_64_linux:  "a34340962c27e38377090ec4e2a707c0fb171d4caf9b2669c0fdc75e499af8e5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cozystack/cozystack/cmd/cozypkg/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cozypkg"
    generate_completions_from_executable(bin/"cozypkg", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cozypkg --version")

    ENV["KUBECONFIG"] = testpath/"nonexistent-kubeconfig"
    output = shell_output("#{bin}/cozypkg list 2>&1", 1)
    assert_match "failed to get kubeconfig", output
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
