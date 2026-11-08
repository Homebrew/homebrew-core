class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v8.4.0.tar.gz"
  sha256 "13c163f5822cf5a839e8d566635e49d51eae8e1df53681110b775e534a938e7f"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "95d94451eb6df6a00ffc31456e51ca7d58b3e44194085ef20a203ed9c1ddc0d8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4b52bd7ca15b433d5ec51b99ef6f42f9afe4aa6f99cc79b7c294748220e182c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f03a5405027b1331ca4377011c7dee4b889bcd0d80f08c0ae2ba9666ac134f6b"
    sha256 cellar: :any,                 arm64_linux:       "e24e3b0ac8c3c9fa0107555c657a212769d690f6a70cd83d6a6875648535f598"
    sha256 cellar: :any,                 x86_64_linux:      "9cbd89e84d98b3938f74ad07bdc65d064c9fa3b70c5e6b68c96455ab08fd0a4f"
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
