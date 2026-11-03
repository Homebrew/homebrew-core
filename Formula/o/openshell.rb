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
    sha256 cellar: :any, arm64_golden_gate: "015d1276f785d5beb539880a3413ebe469216e86393e12c6a9e8e14005cc2d71"
    sha256 cellar: :any, arm64_tahoe:       "f0d15fbbe4aea9e8aa89003adbe7ebe97916b6e1dacb324bd759b1ecc891485f"
    sha256 cellar: :any, arm64_sequoia:     "0b31ecf8ed67c026f99de70c05485ac4ab7c03f4399f015c9ac456676d13dec0"
    sha256 cellar: :any, arm64_linux:       "9e5af269e15ca184ab511e20337ce06eb7f272045abaab1934f93f265db17950"
    sha256 cellar: :any, x86_64_linux:      "ed119a3cfd73ced0067af7e9c176c0a4d1f9e2f6646dabdb9b9713e716338765"
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
