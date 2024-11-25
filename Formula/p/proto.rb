class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.42.2.tar.gz"
  sha256 "ad8ae9aa82d3edfef858558607b2771d2b0866314eaa66768a10228721f9be47"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17978fe061201e9e076e422e2e86c7962e9ed02252a7a696b1e8c339aaa001f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb4d7ed12b255cc58c47449b941264449d49c52bcf57d4b25e0694709f13282a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9e959a3199233e6539f7f0ab6359a2385c4ad45c3df356ce330f20ccda567df"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca577e5940200c1e9a3820421da34caff05f7c2e538f2f56dd55760e533c3402"
    sha256 cellar: :any_skip_relocation, ventura:       "ac3cd3c4f2d482d5611f3b2f21ff87de7991354c15a9d2650b2e439ef294840c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c26477da23c2682e5febda0d176853bcc2544e5000d7002bcca9391b7a13db2"
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
