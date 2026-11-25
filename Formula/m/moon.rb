class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  stable do
    url "https://github.com/moonrepo/moon/archive/refs/tags/v2.6.6.tar.gz"
    sha256 "c488915d88621582274baa829ab85b06451273e409b31d6bafa43b4aba65871e"

    resource "git-url-parse" do
      url "https://static.crates.io/crates/git-url-parse/git-url-parse-0.6.0.crate"
      sha256 "8df306e4dfc91752e89b74c88ee876c8518890600f82255254828f9192dd003c"

      # Use concrete parser output types for Rust 1.100.
      patch do
        url "https://github.com/tjtelan/git-url-parse-rs/commit/0c768bdda9f49199e34d95fba78cadea4cf31f82.patch?full_index=1"
        sha256 "5d86d1dc93c09813622c23b48c1750bfeda976d18d9357853e5270da2a239fba"
        type :unofficial
        resolves "https://github.com/tjtelan/git-url-parse-rs/pull/84"
      end
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "be9836524d69890697f47ca89a4849874c265111667e36997ad842eae8ff9e61"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d652422273f74114188aad87653701ad65892806ff3b585fd517b69b30772217"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58796ac7c710f3a0cf5a1b3b014f49ef3517f182524b1cb6637aa97dc995db47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d6e82f1137bcbf9bde02b636799e0372396e49279d5925b8d22a47ae976489a7"
    sha256 cellar: :any,                 arm64_linux:       "0fc9eaec637c55cfc046a2fac70db9d71bee1d2591ff3a8959a259c4efff2de5"
    sha256 cellar: :any,                 x86_64_linux:      "667074e954b09effea7cfc77386722cbdc33ffc8e6fc1c25f62cd90c4004b9f8"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "xz"
  end

  deny_network_access!

  def fetch
    if build.stable?
      resource("git-url-parse").stage(buildpath/"git-url-parse")
      (buildpath/"Cargo.toml").append_lines <<~TOML
        [patch.crates-io]
        git-url-parse = { path = "git-url-parse" }
      TOML
      system "cargo", "update", "-p", "git-url-parse", "--precise", resource("git-url-parse").version.to_s
    end

    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, MOON_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/moon --version")

    system bin/"moon", "init", "--minimal", "--yes", "--force"
    assert_path_exists testpath/".moon/workspace.yml"
  end
end
