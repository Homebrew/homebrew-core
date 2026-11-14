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
    sha256 cellar: :any, arm64_golden_gate: "60f23f9dbafc87a6930d80d28fed3580073385ef228e6471a111a9968534ecd1"
    sha256 cellar: :any, arm64_tahoe:       "7cd47bdd1337fa961b886edf9a83b40c5776a097f949e2b44e5cd625732e76f5"
    sha256 cellar: :any, arm64_sequoia:     "f66dfaecd742cb60aa90d076ca3264a4ea6cccd99bcc1c3d6cfba28045a52049"
    sha256 cellar: :any, arm64_linux:       "a882a4b8c88c87a93aa1a96f41dee85da1bb271a0578c61a9359ef07e389490f"
    sha256 cellar: :any, x86_64_linux:      "65ed26a0fd0a0726dd78a6bb36cdb4a5b7a1da1b600c2d4f47d76c036f71da1f"
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
