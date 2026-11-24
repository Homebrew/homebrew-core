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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f1b383084153312e0e4fd46ff6274304628043dc6de79879d10782becf589170"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d197150328f4d24bb9bb8114ea063b19586718468c7a910a84f2228b75c5de7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ca5fccdc9b424a2659cbb1e38e8996047f617d88d9c73712185883fbcc74a6c3"
    sha256 cellar: :any,                 arm64_linux:       "023dbe714c629639096d0f9fc162afd5ceedb33f7f22a59120132769c3e366d2"
    sha256 cellar: :any,                 x86_64_linux:      "b25e9d38edf225b8870697c3d91239e878e075b425a6c57b7927012581523d91"
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
