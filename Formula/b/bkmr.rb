class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v8.8.0.tar.gz"
  sha256 "e6a707660bfb64b386d82a3f481ecd4defb3f11e200e10e91e1d09b76b12ad36"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43819b83621961d979b6aaca30e2fbd8a522f7d5f43d86a57ab780c6e0201ffd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7b027b9cacf69bd7694dc246988986961768773a0355ce09e35d8e75c0d1a44c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e9b1bb4be7ff53ba72ca65299247f5b9aba03103f589742434fc446bd05ce24d"
    sha256 cellar: :any,                 arm64_linux:       "6247fbc9e8f4969cbe995a840e7aa23edf94e3deda50fb637e222e7bad21dbc1"
    sha256 cellar: :any,                 x86_64_linux:      "a9fa849c481f6b9d5ee08c56b510da63ae020923e795e7e44f5143f04b90c67f"
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
