class Openshell < Formula
  desc "Safe, private runtime for autonomous AI agents"
  homepage "https://docs.nvidia.com/openshell/latest/"
  url "https://github.com/NVIDIA/OpenShell/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "b23e5620f6cef35f0f72932a054d97fa0bd8f8f4ef4e7c9c90a293e17b9790d6"
  license "Apache-2.0"
  head "https://github.com/NVIDIA/OpenShell.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c9d79588c8d867efba021ed4c40652ce4fb591c0d4dabb8670be0408e4246fef"
    sha256 cellar: :any, arm64_tahoe:       "5fe3408a552d43a67b884051d53ebcbff2ead3ceecd8c02278ec6fecf5500f33"
    sha256 cellar: :any, arm64_sequoia:     "fea047bca72c3eaf1c7d27107484382f524190bda3c62cb59d7bfadb74f0688d"
    sha256 cellar: :any, arm64_linux:       "7b7e43787b8c54aa9ba0641e99429057072509c659cfb8e6c91629aa5a8dda61"
    sha256 cellar: :any, x86_64_linux:      "f88624e8af90be717087db97cf54c44b1d8da32151211e0a748903db3acf8f55"
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
