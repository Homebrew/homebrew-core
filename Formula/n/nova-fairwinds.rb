class NovaFairwinds < Formula
  desc "Find outdated or deprecated Helm charts running in your cluster"
  homepage "https://github.com/FairwindsOps/nova"
  url "https://github.com/FairwindsOps/nova/archive/refs/tags/v3.11.5.tar.gz"
  sha256 "f901ba3f9935ba7febdd6488a3d313e892a3dcec860c2aa9d1bc2e8b82076e5a"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/nova.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4ace3f30b171a76fb6db17094ce9f859e42269b50749a672ef091a17838478e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4ace3f30b171a76fb6db17094ce9f859e42269b50749a672ef091a17838478e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4ace3f30b171a76fb6db17094ce9f859e42269b50749a672ef091a17838478e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9057f6d61525ea824f707ffe3b3192c0e46c4066cbe061bf93db3aa641821a22"
    sha256 cellar: :any_skip_relocation, ventura:       "9057f6d61525ea824f707ffe3b3192c0e46c4066cbe061bf93db3aa641821a22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f4212ceffdf691db9f8704d35cdde4eb4f551c4a1682616d7583ca3ab640dad"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(output: bin/"nova", ldflags:)

    generate_completions_from_executable(bin/"nova", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nova version")

    system bin/"nova", "generate-config", "--config=nova.yaml"
    assert_match "chart-ignore-list: []", (testpath/"nova.yaml").read

    output = shell_output("#{bin}/nova find --helm 2>&1", 255)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
