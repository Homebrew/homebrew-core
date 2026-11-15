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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "90e8b3d25f0435001d0663c42191a7935b7ac2d347b06e191ccb0728d5c85520"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2076f11dbee46093f59a763da3bb955c3b4f246bf148d9abd903a7634075a46f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fab09a44b84d0317a0c14024971c09326d0cc9fc9925b3ccbc06180986d6b795"
    sha256 cellar: :any,                 arm64_linux:       "6497a4c32e5c98eb9675ea16d7f9e30d4680706f6441c0e24061661441e15d0d"
    sha256 cellar: :any,                 x86_64_linux:      "6abcfe1428d7554423305816c09d71096b4c430c4b231bfcba682a8956434c37"
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
