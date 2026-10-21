class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.63.1.tar.gz"
  sha256 "e37ff82eebcecd23c36818ffcbe54f10d2e28c924cfe3d55b24512573dce0520"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "480d9dee8b2a505e20ed6d9656eb945d3281f898e58a99d4c4321011feaa6743"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "079792635f2843a326db4d0984466a84a3e078f4ac186b12092268fbb244302f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "564d9ccb11da3bdee41bf71a30fa7606837af0ee704ee03044a367e23efb9fc5"
    sha256 cellar: :any,                 arm64_linux:       "feb87a110b3725724d77c32b48a570b4f9f75960ecfbf5cee7fe69f4f5eaee3b"
    sha256 cellar: :any,                 x86_64_linux:      "8e238dceb9c80ddbcaf0e08125f0a7acdfd014e2f8303d64da1b86a53b6a38af"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "xz"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
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
