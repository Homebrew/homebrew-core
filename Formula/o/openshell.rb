class Openshell < Formula
  desc "Safe, private runtime for autonomous AI agents"
  homepage "https://docs.nvidia.com/openshell/latest/"
  url "https://github.com/NVIDIA/OpenShell/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "0f41d081acffffd3deed8111001dc660186f8b6e72beeffd3fbe7da496845c0e"
  license "Apache-2.0"
  head "https://github.com/NVIDIA/OpenShell.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3e7a1b0d2dc584c6bc7da8ddec40a04f1860bfee368e3be9c5e6a623b5ee6e31"
    sha256 cellar: :any, arm64_tahoe:       "667a6738e08ea923f592ca6af269e1883c373606c8e77adf88b1b35052602f1f"
    sha256 cellar: :any, arm64_sequoia:     "fd12d652429439b8544e3d994d655cb6f6f9c2a723449cf8a43c670c75a17e8e"
    sha256 cellar: :any, arm64_linux:       "ade819bfe74a1ccaef9f96f41aea039566482d8cc7270ff7f908e8fbc4a3b95c"
    sha256 cellar: :any, x86_64_linux:      "916442af4e0f3543ac80062b5a13d2ea894b5c6466c3244ba814c90c608a2ddc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "z3"

  allow_network_access! :test

  def fetch
    # Upstream stamps the release version into the workspace at build time
    inreplace %w[Cargo.toml Cargo.lock], 'version = "0.0.0"', "version = \"#{version}\""
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/openshell-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/openshell-prover-cli")
    system "cargo", "install", "--no-default-features", "--features", "defaults-without-telemetry",
                               *std_cargo_args(path: "crates/openshell-gateway")

    generate_completions_from_executable(bin/"openshell", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openshell --version")
    assert_match "No gateways found", shell_output("#{bin}/openshell gateway list")

    (testpath/"boundary.yaml").write <<~YAML
      version: 1
      filesystem_policy:
        read_only:
          - /usr
    YAML
    (testpath/"candidate.yaml").write <<~YAML
      version: 1
      filesystem_policy:
        read_only:
          - /usr
        read_write:
          - /tmp
    YAML
    output = shell_output("#{bin}/openshell-prover check candidate.yaml --boundary boundary.yaml", 1)
    assert_match "counterexample: filesystem write /tmp", output

    system bin/"openshell-gateway", "generate-certs", "--output-dir", testpath/"tls"
    assert_path_exists testpath/"tls/server/tls.crt"

    ENV["OPENSHELL_LOCAL_TLS_DIR"] = testpath/"tls"
    output = shell_output("#{bin}/openshell-gateway --port #{free_port} --compute-driver kubernetes 2>&1", 1)
    assert_match "Failed to infer configuration", output
  end
end
