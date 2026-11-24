class Floresta < Formula
  desc "Lightweight and embeddable Bitcoin client, built for sovereignty"
  homepage "https://getfloresta.org"
  url "https://github.com/getfloresta/Floresta/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "47b0526b9b669d51ccb1ddce0df8f5d9f8c6bcbaadd5f5b4bbbd5416ad343bae"
  license any_of: [
    "MIT",
    "Apache-2.0",
  ]
  head "https://github.com/getfloresta/Floresta.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "240fc5920b9141f7efb15f1fa5f9115531304ff3b23bf1f76b779afe24607b61"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7110e171368143ded5455d58859992bad165df499d1234a4e60a649be75f7df2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "84484810a6b1741f79869c3b2936b7033a9d8be92f9fb8c735038301fe255a5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e2d2cf34f0f0767985577ec2fd55eaf5ade8a81ac68061823d3d25a3a7405bfc"
    sha256 cellar: :any,                 arm64_linux:       "5389c1b5648070768965d3e767058399dd5d684c7ed522d2607edca6e09a5c38"
    sha256 cellar: :any,                 x86_64_linux:      "78346f201611e830ffcb5d07a2b9a37b65493390cf97411b9dcc100fc3d435b4"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm").to_s
    system "cargo", "install", *std_cargo_args(path: "bin/florestad")
    system "cargo", "install", *std_cargo_args(path: "bin/floresta-cli")
  end

  service do
    run opt_bin/"florestad"
  end

  test do
    with_test_process(bin/"florestad", "--network", "regtest", "--data-dir", testpath.to_s, signal: "INT") do
      sleep 2

      output = shell_output("#{bin}/floresta-cli --network regtest --data-dir #{testpath} getblockchaininfo")
      genesis_regtest = "0f9188f13cb7b2c71f2a335e3a4fc328bf5beb436012afca590b1a11466e2206"

      assert_match genesis_regtest, output
    end
  end
end
