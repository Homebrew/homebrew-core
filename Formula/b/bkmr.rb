class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v7.9.1.tar.gz"
  sha256 "814bd6efd092eafaee2d07a720c969ff7fe12706444cc33547c10219713d47f4"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b110d495f389290cbefe94e4015b5688dd1ac3c4e38845270fad4dc364427b90"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4bb6f0d32592ed0726747c8176cce174e2e354fe4d58abaa82caf28321a9d169"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0e97fbc49292029c30ab722fef41e32214db7e4dc876d6b63466a7706725c9da"
    sha256 cellar: :any,                 arm64_linux:       "b1891491a9593418bc26c07e364c845fe7ad003393313a52a7f28b01e07a9365"
    sha256 cellar: :any,                 x86_64_linux:      "1210a929a217d412e8dec54819c331bc85f6e9e5fc03b817b3e783e13a7bc0d6"
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
