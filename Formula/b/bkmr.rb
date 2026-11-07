class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v8.0.0.tar.gz"
  sha256 "244016dec16bf786ab4f5c6ec5a57a10ea8e63510488496244bd853777202860"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4883ff4e230d73bb7381d60aaa0df9762fdbb36e50900fc28ec3c6a2ee06a0d0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e1b94bdb66b8e27522830a65cfb86f7d2676f13514c3525c2287cec5e8f6b011"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "390d1a1c069a63c02a4baf9b463fed9c28c9d6feef1315a48eca434d8b6b1ea3"
    sha256 cellar: :any,                 arm64_linux:       "a982cef84a3de6f99f84ef0d938f0556b1eb146fb085d9fa4a8314e05a84d638"
    sha256 cellar: :any,                 x86_64_linux:      "4a4c8f5a89181b39f8027222705c7da1ead18e4b2c1125f82e36d66d4ea0767f"
  end

  depends_on "rust" => :build
  depends_on "onnxruntime"

  uses_from_macos "python"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "bkmr/Cargo.toml"
  end

  def install
    # Add Homebrew lib to rpath so dlopen("libonnxruntime.dylib") finds it at runtime
    ENV.append_to_rustflags "-C link-args=-Wl,-rpath,#{rpath(target: formula_opt_lib("onnxruntime"))}"

    cd "bkmr" do
      system "cargo", "install", "--no-default-features", *std_cargo_args(features: "system-ort")
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    expected_output = "The configured database does not exist"
    assert_match expected_output, shell_output("#{bin}/bkmr info 2>&1", 1)
  end
end
