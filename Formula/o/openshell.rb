class Openshell < Formula
  desc "Safe, private runtime for autonomous AI agents"
  homepage "https://docs.nvidia.com/openshell/latest/"
  url "https://github.com/NVIDIA/OpenShell/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "ea6c2dcb50b3ecb3c7bf3d8b5ae4ada71eee838a1a2b12f7a1d2ada76b0837b9"
  license "Apache-2.0"
  revision 1
  head "https://github.com/NVIDIA/OpenShell.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6575c46b25acdcdb68350a37c7b3829c6fa2e6164abf96df867adc67d192fde4"
    sha256 cellar: :any, arm64_tahoe:       "2dd09644ccfbf1cf2975e6322e586cc76b69c16e358dd1f7ed04e22d135345eb"
    sha256 cellar: :any, arm64_sequoia:     "8937c3046b7dfc3339ae080a1fb5828b2bd11c0ba7e63ecf71571e146ec9d0ce"
    sha256 cellar: :any, arm64_linux:       "6c8d082d425e0d1192b9350d7fbac3137cb7cfec8ebde8b3a8511689163e5cd0"
    sha256 cellar: :any, x86_64_linux:      "f4b79a4bbec80f6016a3e2690aa162e31c2f2a82df4d5f78f3be1129e171dfa4"
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
