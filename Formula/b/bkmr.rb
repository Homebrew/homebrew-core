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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a311f1c54d7f5cfe0cc6690a25febb839e4a918786fb9df071cb072c5ec677b8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4b1274767365c6138dc2ffdd88101059aef0814c9f832bd1c62a6927520652a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cbcfcecd674abf8b31862de13ed1ece4e39b3129a3f36bd17517871814b5ffe5"
    sha256 cellar: :any,                 arm64_linux:       "1aff8d536e0e4ef2ec0895292649ef111044d2d3d67eba98f0253ae34d322e7f"
    sha256 cellar: :any,                 x86_64_linux:      "7f0c40c52cd8c11d203a69d777e3c30618fb604edbfa5c069c74b118acfe76d0"
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
