class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.50.2.tar.gz"
  sha256 "25e897c8086428feb67a272dcee1b7e7870b0746e3f82dc78adeb7ac6ac5e8c4"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af8aa94466c804a9cc6f7d3528d8fa3bc5a1f692ac71e1ca6d6ea75412ed8598"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92a9dc64aa32df8b2b2a7038b666187cda90b3e4fdb19e4080c2c9cac684d25a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0ffb7c0319ebde773c048c2c05091b6d9b3a709898febcf7a747a36fcfb4be6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbe567b5cc0ecbb2bc210c9f36900ac1a6727b218bbd55e915fa4e5e165f5ec0"
    sha256 cellar: :any_skip_relocation, ventura:       "f57810d85cea20b34040d1c90caf87bc72a36ba3fcf009fa1a6885f13b86b979"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e53077aa5e3587f928fbda0255c6896d4d1cb922bca27d3a08fd5f6d9d2e6c66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5f453cb23a69362024c821fa6cc4aee857969fd6d77a08cc74346045d8067c8"
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
