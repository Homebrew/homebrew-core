class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v4.1.7",
      revision: "21748f1a8b8df09c8f8b1d8d3c8d701d93991f29"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    manifest_sha256 "7b3ede06a809e24314c743ccd3e9cc3eeb33b9f9f2ec3227fd637bb8eabcf167"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c1132ef596104352a8bb7c6875e00f5ffd3b641271af8dc5f2a83be997c3049c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fc3b60d11c05069cb2cf83d865f4d86e7e8f67ef9fc67c557dfce0298f4978e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "faabdc36a6ae6a97145ac5c113117a0f523eb975802c575f27e73629e3f5d301"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1cb0a21121ca1a971d1bb254f6264e0905fcb9662ae68aaaed0fe4249a3d4793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "72b1e900d4cf46fe1fd4483cdd6d14204e2669f406a6cd762697fab603abc493"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  deny_network_access!

  def fetch
    # Run targets that need network access to fetch Go modules
    ENV["GOPATH"] = buildpath/"go"
    system "make", "#{buildpath}/go/bin/openapi-gen",
                   "vendor/modules.txt",
                   "pkg/apis/workflow/v1alpha1/zz_generated.deepcopy.go"
    system "yarn", "install", "--cwd=ui", "--immutable"
  end

  def install
    ENV["GOPATH"] = buildpath/"go"
    system "make", "dist/argo"
    bin.install "dist/argo"

    generate_completions_from_executable(bin/"argo", "completion")
  end

  test do
    assert_match "argo: v#{version}", shell_output("#{bin}/argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig ./kubeconfig 2>&1", 1)
  end
end
