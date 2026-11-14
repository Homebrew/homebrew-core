class Magika < Formula
  desc "Fast and accurate AI powered file content types detection"
  homepage "https://securityresearch.google/magika/"
  url "https://github.com/google/magika/archive/refs/tags/cli/v1.1.0.tar.gz"
  sha256 "87fd85f33d2c644d657de024b83cdc36bbdcf4a2961be5e93fe74e081477076c"
  license "Apache-2.0"
  revision 3
  head "https://github.com/google/magika.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cd7658a3f2696ece09629627b7fd7953b20b3dec41bed24fb51fbb653f9d0234"
    sha256 cellar: :any, arm64_tahoe:       "cf634d0f8e53d31ab6ce59f36e02320ef04939ce402afca1d37c8271fdf543db"
    sha256 cellar: :any, arm64_sequoia:     "c1857280a7557860c9977d938e6dc9322f89ea2f32b35e28cd9c02179ed9172f"
    sha256 cellar: :any, arm64_linux:       "1790bd9fcb20066cc91bd0a1f8e238536815578c04987c656e102628a2b42bf3"
    sha256 cellar: :any, x86_64_linux:      "937b70d06afa0e7e73f1ae9594fef74810fb845e15bb4dc619ecd31f0f879105"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "onnxruntime"

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "rust/cli/Cargo.toml"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    ENV["ORT_LIB_PATH"] = formula_opt_lib("onnxruntime")
    ENV["ORT_PREFER_DYNAMIC_LINK"] = "1"

    system "cargo", "install", *std_cargo_args(path: "rust/cli")
  end

  test do
    assert_match "text/markdown", shell_output("#{bin}/magika -i #{prefix}/README.md")
  end
end
