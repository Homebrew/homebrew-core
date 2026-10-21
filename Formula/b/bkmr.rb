class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v7.8.0.tar.gz"
  sha256 "0427d3ee521a9ab0a333d8fe31cd47fba7eb15f5cf8a4e687857b0761078a2d8"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d932f05ce03072bfc724e8110c4efd6976c53ae692a70cdcc0560b119fff328d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9af94e6496f2988e498cf74157b0fb8a4aef443614302e8667bdc3dc2182bafe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7183762b7056f430ffa91b8383f47e94102a4e34639f0d73b7e23af6b62efc9a"
    sha256 cellar: :any,                 arm64_linux:       "3f76b79d33b82adea61ea0e83494d98c380e42b6a99b8d92c3466691bce894fb"
    sha256 cellar: :any,                 x86_64_linux:      "5ab83063209d60d29806debd4527aec0bbc7fd0400047a29f5f43b5b5fde05d5"
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
