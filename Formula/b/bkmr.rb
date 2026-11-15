class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v8.6.0.tar.gz"
  sha256 "8ed0494fdc7556817b7c79a70bc5799a41ece09553812f6d6962a187c0cfe9c1"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05b513d6d314a4c899a6192a71836e3eba819432541ad5e03b96baa9778d982f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2482e16646b1eaa5b47e425b93550d0545035232deebe5d4218a0fee60dfa12c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dadc5047eaea2cd5d6b4a43e45c09a643813270b768c60af060b2f1db2e4e20f"
    sha256 cellar: :any,                 arm64_linux:       "012daf637b311c12ab33d8dd3196a649f6b62be6f7938174f405f3046ec3b3f7"
    sha256 cellar: :any,                 x86_64_linux:      "91e99292f5788a1ce1951507d7edda152009c82db8576e297dea6a6740094d91"
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
