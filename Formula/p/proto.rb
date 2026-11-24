class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.64.1.tar.gz"
  sha256 "104fb7c9bc6873f993c6c412366ef82e246c3a6ee84d8dc690505720afcd9179"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "14e8c2bbce8fbe8e277b988baa5e9bd285aadd06785a4aadc1818ee310b0281e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6f88c71801fc14af5cf46538b92d13e27ba60bff07e9bdf2b6c71f1e22c37040"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8fc7ab4311cf737fb8011ebf21e186f81694b3e5d9b23c78563dc2c87017cf46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "268f4fb83a40e926356eac08ee6f9fed52dbed3d9ed710e5d856e75ff6b1079f"
    sha256 cellar: :any,                 arm64_linux:       "ee18b9626619ed6b84c74eb9262a49b859d19995a0e2d42b34d6670c9f70b0e6"
    sha256 cellar: :any,                 x86_64_linux:      "80ab93a97478e6bb7cd05c961103e4101aa623e6ab863111255f2268b87051c4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "xz"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix(dep("openssl").name) if OS.linux?
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      # shimming proto-shim would break any shims proto itself creates,
      # it luckily works fine without PROTO_LOOKUP_DIR
      next if basename.to_s == "proto-shim"

      (libexec/"bin").install f
      # PROTO_LOOKUP_DIR is necessary for proto to find its proto-shim binary
      (bin/basename).write_env_script libexec/"bin"/basename, PROTO_LOOKUP_DIR: opt_prefix/"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    node_version = "24.15.0"
    system bin/"proto", "install", "node", node_version
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match node_version, shell_output("#{node} --version")

    (testpath/"test.js").write <<~JS
      console.log('hello');
    JS
    assert_equal "hello", shell_output("#{node} #{testpath}/test.js").chomp
  end
end
