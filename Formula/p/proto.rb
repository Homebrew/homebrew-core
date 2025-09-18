class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.52.5.tar.gz"
  sha256 "3e804f4ce75980c48a8eea32af81b99613d97ccb5a0318c2cb3d21d9b3bdff3e"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61b24707f5a5b5753fd408e89739938fbf43dffcb6af5382f63bbb8be7af45b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fc68e74366f0aa7f7f4a3119e55bc85bf093116f74e6735d84e48bcf7d47133"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d43033d5a341f676dc24c8700e58556dca26578708fdc849aba154bdbad3228"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd1a89aa95185334b383dfd5020426855a1d54c639c45baf220c7928869d6e84"
    sha256 cellar: :any_skip_relocation, sonoma:        "adcc0c0d11b72070f72f7721dd8d6775f0feb7947e877efec55bd534a34e1911"
    sha256 cellar: :any_skip_relocation, ventura:       "3ea3cea068081dac8f159ed023b1ac0a8e6b2a565fe3c2502c8f2240a3a8aed1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f4931c4cb1f57ae456b5dc6822d0d89d4ab560d471ee1cb55bcc006d9ae4695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ab39754448622cd76cc4b1ccdabe9f010e943f4fe1ab29d215286eee3c1acfd"
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
