class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.56.1.tar.gz"
  sha256 "d3e0a8a423d8ca3641acb5f90d079ab6f2460c842b1c13c8e8aa3ed7ef99af47"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee2eecd793df72b1ecf7a36622c2996263647fa68e463d5ca319d0f1e1950f59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22271de9eed5cc14305b8073d812a28201191c0c0ce7cd1b9eef41c8bf558a32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d66840a97aeb888dfcfb9ec0dd0362dc723d6714aeff13b7c69578b43dd2e96"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c0f4bd11e16f22f646649c14d2a6a1640859908ea529cd9e6dd91dd5f5e3934"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5bad0d2ef9229fe091571f5d167ebfdf8b8505e81461a00ac4921092617ec07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afd7bda8472ddcad8a37f150b1d876afe8184e35846f1ffa29bb7a0b8a5aa64b"
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
