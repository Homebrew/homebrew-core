class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "dec204e18be7da765af800b5e3634e2fc462a70980bcacdacb4c751059a9842b"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ad58ea9a8deed173c8c24ba3965b0e12b1efabf20a98be24a4cb125716f3488"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b777c70710f6869c8bea756832e009350af4582ba7af48f6019e99f38aa2067a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "153986ea9cc22697c1f947cbaaba83e849c0ed727eada06641ef21ecb69b1f41"
    sha256 cellar: :any_skip_relocation, sonoma:        "59c0f3afde2d1b59092e090fb62e57d771da5ae801ca543d12abf90db88dec9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aae2e1469e6e386b8ccadd197c8b339462884ce699070bdd8fa82799f878f3de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32f5ff6d0d9248e6f9fc8c9ae05a57d680f2f76090ee2ac8890e5115f8efc212"
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
