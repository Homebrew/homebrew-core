class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://github.com/o2sh/onefetch/archive/refs/tags/3.1.0.tar.gz"
  sha256 "7381912c62ed1c8a3b1a443afac2fa22d8a10db8414cd44198c5d4997fab0d54"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "233bb972f47ac36e733f5a90cea45d6f7bbf782e1d91f51e1c586aab964256f8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75778b495504265d68d117bd6cedce95f1b892815f69e15f70ec98a13930d603"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "830edde54475ad69e07d492f4f88c9ac91e2d5e36586fcf0f4ea8cf223957272"
    sha256 cellar: :any,                 arm64_linux:       "cda3ca78eddbc0cbca9be5289f8302d7578d61c9ab97336c0e4b6a0a024de337"
    sha256 cellar: :any,                 x86_64_linux:      "4afb18872d9853223d6c77e68ca8296eb9c38182d4558b61f4547bc6bcb4fab1"
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
