class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v8.5.0.tar.gz"
  sha256 "5c896c16d103f3461eb1188db0cb48dbdee03c17532e4c1fc9b4b51515e68592"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e97de7933998dc673883b43f3db4e876246539fcda36ef7d82b15647bafa3ebd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8cb3c3a0271d76b8c3f0ea23f904e0ba697b6580516797726f3667490b744dbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f18c5914f5637cbb5e2859f09c16c2bf1d34f8beef9874209ab02af3d3271a5e"
    sha256 cellar: :any,                 arm64_linux:       "df53479435a04470b7849f46678eb7cc4170c6c825664396d4c92676d3aca3f1"
    sha256 cellar: :any,                 x86_64_linux:      "543d43b982ad944407a4685cdb9c10b8e7422a4ce69eeb3aa7818b046527647a"
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
