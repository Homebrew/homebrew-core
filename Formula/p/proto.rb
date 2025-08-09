class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.51.6.tar.gz"
  sha256 "cb46d124e52a6413e42486d24a4cc8fe6c8c4aea06ca4afbae8371b54e2cf298"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8df512701349f31ca73070bf53743582c4f2949a8417ee090a42cb1d6d97d4f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5afe1bd1d74eb3dfa352ed472f7e9b08900cd8f6f94e84236cf9274ce37778c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb9f88dc72e476f4fb18bab2440f8e36c9f24a060826b633c477486b55c9280c"
    sha256 cellar: :any_skip_relocation, sonoma:        "dabb24bfc8abc4a267680df2aae2a3deb6818771a3a4902b7a0aea455de92280"
    sha256 cellar: :any_skip_relocation, ventura:       "47f4e47e96251524e8726fc9403ff209a698a94f1459ae6a466bfa94603edb5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0d5ad9221f01a7523f5b97e67617badb8603134a410b1c0b1f1c2d3645897bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77c5ac73d7be1e2d2836d770824e41e36eab38a14cb173d3e2fa3dddad9e7dd7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
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
    system bin/"proto", "install", "node", "19.0.1"
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")

    path = testpath/"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}/.proto/shims/node #{path}").strip
    assert_equal "hello", output
  end
end
