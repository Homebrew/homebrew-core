class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.62.2.tar.gz"
  sha256 "5cd3baab58dc0ff8055fae009f820f7fb029112a4b083679ed33b4ccb4c01909"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "145cf7bb9d4ac54b3bcf76b6718e3d98c108603f5656b54c136ac91ce98f5818"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5613335038eae9a53bfd78fcac73a6da8c9edfbd223c55529cfe639e921cffb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e3944da706256a29bc327e4557f61f20f2bf721e16db9a23a4f32ea37605ea35"
    sha256 cellar: :any,                 arm64_linux:       "15bb392aacd57f9ebcfccf4cc1402dd05e238271c85a19b53c687b118c17a67e"
    sha256 cellar: :any,                 x86_64_linux:      "2837e1b2a457d867fa9a69e174d90339021858d38fee7077c49dea976d76f6d5"
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
