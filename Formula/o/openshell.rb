class Openshell < Formula
  desc "Safe, private runtime for autonomous AI agents"
  homepage "https://docs.nvidia.com/openshell/latest/"
  url "https://github.com/NVIDIA/OpenShell/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "bd17cfc1ebf79892ba4a8ea806af098aad25b22ac13d643a06bd09fd0e0f2c3f"
  license "Apache-2.0"
  head "https://github.com/NVIDIA/OpenShell.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "a679de4c4a449b029d01d777d61a8381e352a8b441e783a1368f153740ce5163"
    sha256 cellar: :any, arm64_golden_gate: "2a137f5337418d972e8965f02aa5e69b41a8d89e481ce4041f7fb6e2b7e926d0"
    sha256 cellar: :any, arm64_tahoe:       "38f0ab0774dc69fe3b126e2e38fa8e03c9636b0bba5f6d117c71e350b010b968"
    sha256 cellar: :any, arm64_sequoia:     "b9dd92ade944aee62e82edb211fd7272453e1e2e490f037e71701aa3cddd9bff"
    sha256 cellar: :any, arm64_linux:       "b0a11758fa3398e5c16a45008c5b917cd18c27937d5fb42e299b2014dc474bad"
    sha256 cellar: :any, x86_64_linux:      "d0de0c83b43af95c3cf9885605de5df1950094d1557b211b27b390dbfa29688a"
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
