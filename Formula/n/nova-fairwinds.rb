class NovaFairwinds < Formula
  desc "Find outdated or deprecated Helm charts running in your cluster"
  homepage "https://github.com/FairwindsOps/nova"
  url "https://github.com/FairwindsOps/nova/archive/refs/tags/v3.11.14.tar.gz"
  sha256 "7b3ea0cef7fe8ca696b6a0874c746bad2b6c1089cf65be9744c8cd72c3ceda66"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/nova.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12b303f754d3556e3015c7b4af3613562a7fece54830313f235d0d1d4c2078ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12b303f754d3556e3015c7b4af3613562a7fece54830313f235d0d1d4c2078ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12b303f754d3556e3015c7b4af3613562a7fece54830313f235d0d1d4c2078ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb7a6ac8ec4d803abf2a9cf3d010570e2bea9e4e2eaf89b56dfd56d5de2a4e1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b50068620789bf211baf7d8aaa8ba9387a97c05ec5290ddb4da001c7a12ac3bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77c85a5e5a8ae65b5e3ef5c6eb6edbd3b507c362be667b79022db1984982c6e9"
  end

  depends_on "go" => :build

  conflicts_with "open-simh", because: "both install `nova` binaries"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(output: bin/"nova", ldflags:)

    generate_completions_from_executable(bin/"nova", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nova version")

    system bin/"nova", "generate-config", "--config=nova.yaml"
    assert_match "chart-ignore-list: []", (testpath/"nova.yaml").read

    output = shell_output("#{bin}/nova find --helm 2>&1", 255)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
