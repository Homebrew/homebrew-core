class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v8.10.0.tar.gz"
  sha256 "1fc2363d5beb18963a1393ac542ba075d38aac1b7b2135567de08ab97b9e134f"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "20fe2e3cd6cc38f50965f22bd4d6d76b6028a88af7fdf4b5e92e48422e7295f2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "40b712ebd603acfd9fb017fe1404036e99d25721f70d71bda52cc7a87a2a3295"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f6c4b19a1e0ae47e5570db52143cc4a8cdb31e3d96f2b9e0046fcd317c0450af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ed75e3d326e2e5ae159efb25fa678c712c4410eb3554f72d07d9e987aba49ad9"
    sha256 cellar: :any,                 arm64_linux:       "68cf55261905b4e2e1c60ca584d107d27b08548fbc21a2c19f771e16233f1c04"
    sha256 cellar: :any,                 x86_64_linux:      "e770d380a75a396efb0635fc88575288706dfc2f93e194a5c06771b24e97b963"
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
