class Cozypkg < Formula
  desc "CLI for managing Cozystack packages"
  homepage "https://cozystack.io"
  url "https://github.com/cozystack/cozystack/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "3e75653d1f70dad368b8eebf6860093fdf3419699171535518d10e7492f101fc"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozystack.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "dab8ce038f64f95a7efc8316327a6bf022e3d6a1e13727e94a0d55aace3da1e9"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "06f6e3627c0418fbd7a9e27fdde4cd3b5a07a737f3533ef6c4da1e057221a595"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6226c3054935b09bb3ba0724d04f09bb89d291a1fd6a45d7556d93dab17c151f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6e6219e1fa2300c24cc2f621fc2205fce31338ba6114d1cc5deed633528f2f43"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8d9fa34cb22f332b54cafae3ca7fe6ef716f54dc5d4a34e44bb3846c52ca4b48"
    sha256 cellar: :any,                 x86_64_linux:      "c3a34171b8c038fc8964cdb9fc0173a4138fd57a4e4f85eabc42661c75059628"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/cozystack/cozystack/cmd/cozypkg/cmd.Version=#{version}]
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
