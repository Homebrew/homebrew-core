class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v8.9.0.tar.gz"
  sha256 "2112fd8c1bce8ccfc41a8de21e4b0b37fa8894ee0a0cc8058c4a8bc43198299b"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b0074f7e4dc544e000d0f81d7622724e0f9cb05885412ad0155b48a2b09007be"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c899bd26be83fdccd5831cbecf04dd3fb5bf88fa8919abc77f37636f8afa6388"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "064f844502572a824685da4526dd19034b84466d755844be27a39b109387b5bd"
    sha256 cellar: :any,                 arm64_linux:       "33eb05384ee17d46236721e384ca64a769892c7a65f27823bd48e5eab7f4a45e"
    sha256 cellar: :any,                 x86_64_linux:      "5a16fca2a1d2502be1b80698462fad140eec861bb4e1859e4ce181e834024b6a"
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
