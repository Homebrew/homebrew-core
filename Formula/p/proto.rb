class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.50.4.tar.gz"
  sha256 "65ace991bfd190f71edb99a1e712b2294f39fbc8930df7b1f64f4e987360e7f4"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b583d50998e663c178b91d71859bde30c905356d51050f6b5b809fd282695ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4253065726864298bf65c8f10a15a8a423dfaf97e8c399822f59e4540e655ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "732d995fb59d8a058e54c8d334841739044b9d55889bbe5e39e932e803be188e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f16ab80e8a8bf300520271e4ff2f4a1fa96aa6b6a90510dd1b92a6c86e06323"
    sha256 cellar: :any_skip_relocation, ventura:       "175a71528173eb073c64812dabdc03f6e10da840ff7686f178a88e83aeced6fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32c87758f8bba037a9622444bb6d04d35dbc8ce6c9564a6bd108a1dee9426561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ca866aae6f6e88a064a36088126c698b1b20dd034c376d92f6d528a54f98d68"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
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
