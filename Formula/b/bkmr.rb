class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v8.2.0.tar.gz"
  sha256 "ddcfacb698710ae9597fcbf786d0c93067addbf4a2404e2f471d296a70ab3b5a"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4d9c9222e82f611b276cf533d17a5f01c078b199d7e188ca362c3df7f06b4319"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fb6fdf31c2716578a4e28b4c17f9736e7ba123293f195cafbff253ae83a11263"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5ede0864f882ce2fc08fdff46dc1a570f5bda5c31ea5c5edfca67fc953e611b0"
    sha256 cellar: :any,                 arm64_linux:       "ba902e51c15458773acdd07010ceeced70ab06a320828629b53cc37d5aa1587e"
    sha256 cellar: :any,                 x86_64_linux:      "89286c318df264fc9f0ded58bf6b9fb7b5ade1dc09f262e0139a7de970c16fc0"
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
