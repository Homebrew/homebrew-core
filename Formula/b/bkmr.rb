class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v8.7.2.tar.gz"
  sha256 "e85f26e9acdef2a70442df5c1ea2ff7bbccf5a8074f51cc71c58787675c08d7d"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ab926e4a4161c1d6c76860b8fdd8929935040ad95718aef4a7098de541f86d2c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e5b742ffffc3f552cda700c0bec08bf315f4b9a9e3695b6adc64b98644c18977"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "def7c7f019f4f9bd69e95b86952ad219df9e21d3e7530dd4a5aa17f7a7b4e8b3"
    sha256 cellar: :any,                 arm64_linux:       "524852a9f31f21b3526303a18e3dc397d01eb6d9f6f9c90123561701355da74a"
    sha256 cellar: :any,                 x86_64_linux:      "2731d069743498778b0775d869805b3210151d828834e4a051e0603a9587ba3b"
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

    db_url = testpath/"bkmr.db"
    ENV["BKMR_DB_URL"] = db_url
    system bin/"bkmr", "create-db", db_url
    system bin/"bkmr", "add", "https://brew.sh", "homebrew", "--title", "Homebrew", "--no-web", "--no-embed"

    bookmarks = JSON.parse(shell_output("#{bin}/bkmr search --json --np Homebrew"))
    assert_equal ["https://brew.sh"], bookmarks.map { |bookmark| bookmark.fetch("url") }
  end
end
