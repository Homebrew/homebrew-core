class Cozypkg < Formula
  desc "CLI for managing Cozystack packages"
  homepage "https://cozystack.io"
  url "https://github.com/cozystack/cozystack/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "a227ac9b0d7998c105c92b72781f4e04cfcf6273293ef9c96232eb14074ad14e"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozystack.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "4a75a69f0f8e3d92854eefa21ade49bf6214afdc6c929088532d5fd162931ca1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b2dfd6a6a6864a19d752865f65d98c0c31ab01131ba3bd20a42733f710b26a78"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "64661f245174294788e92e77b51edaf8661b7de1190eca8bac766668abbcf9ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1db42cf045acda6f638068d2dda8c4fc53798a5611f8a186624f7ba6216ec580"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9517347a3223de52b0838acb3ec20eb3667ad4e278129b375b8682bd2342891b"
    sha256 cellar: :any,                 x86_64_linux:      "52b86f8b86179a9f99b2ee4f0b833c3cecb7025277e9474ea19ed2e7fa1c1195"
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
