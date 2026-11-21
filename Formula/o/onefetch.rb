class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/refs/tags/3.3.0.tar.gz"
  sha256 "bf9122e9e28a6d645092b20b8b931fe3eba08a94fe21679169ef39f016afe892"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    manifest_sha256 "6de1a06834faed7e37f4b0446fb32af9115545bdedde101b5010ad4a2f8211c8"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f3958465fe0855424573564e94185acd601a3ab298044edb770e8ea0105abf5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd8681ac17a705b489dfa06436f57b4be2fefc8252d1dd553c88f99a1ad021a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2c374310696931ee92dd8f719a4f32af4947fdd72c8041cf8cf45484ec7b575e"
    sha256 cellar: :any,                 arm64_linux:       "9705e7c2148911476445ce75fbbfe81bdc6e751eb7403267fd296ec5236bb43e"
    sha256 cellar: :any,                 x86_64_linux:      "85b912920942964455cb91211d961d90eb57e355c26b7d4b22d93ee881582212"
  end

  # `cmake` is used to build `zlib`.
  # upstream issue, https://github.com/rust-lang/libz-sys/issues/147
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "zstd"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["ZSTD_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args

    man1.install "docs/onefetch.1"
    generate_completions_from_executable(bin/"onefetch", "--generate")
  end

  test do
    system bin/"onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    (testpath/"main.rb").write "puts 'Hello, world'\n"
    system "git", "add", "main.rb"
    system "git", "commit", "-m", "First commit"
    assert_match("Ruby (100.0 %)", shell_output(bin/"onefetch").chomp)
  end
end
