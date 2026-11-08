class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v8.3.0.tar.gz"
  sha256 "f1f994ae601978b541bb2874c0b6f90abd9bbc9626225460b0b31e2e5890c413"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8c332c97f181499863d68e1324e9d7013cb37f48c6a60ae95d1e1de75eefeb87"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5001dc1b379fdd410b7c5a2e19d6dc43dcb34da6f1a377af83c511fd493cc21f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "53955e8d3ad32bb603b3e3f93e9de59bd40550c05836031370358eba1b62b3c8"
    sha256 cellar: :any,                 arm64_linux:       "a21bdf0de156be19b73b7223f7c5a6319b75309419ffc29f9ce929fffc7862bc"
    sha256 cellar: :any,                 x86_64_linux:      "e81fc8c48b395130d6be89fc07e23b88ee16c240e469f20914c9f467c9a61313"
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
