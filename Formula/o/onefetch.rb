class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://github.com/o2sh/onefetch/archive/refs/tags/2.20.0.tar.gz"
  sha256 "385bc8f11c3e1cf168ef6d4c64263ded44af948184a990611c1b30fe6c46e37e"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3be44fe6313ca0084e8c72a08bc59de0ec8cbf78b39d52ce4dd3d2ce59dc1d43"
    sha256 cellar: :any,                 arm64_ventura:  "bb298ddf13ddb14cecd0f0cd5fdc40cda096b8dc5d849d922eb7a63206be54f4"
    sha256 cellar: :any,                 arm64_monterey: "11736834baa60ed02ac4b0e8df44783ae2fe17b7ec12a6f2fa2a1ccd36b29948"
    sha256 cellar: :any,                 sonoma:         "c596b6bbadccb7aaa995eb74a9e4eb14bbb16f70a4070996fbc30316f4007d7a"
    sha256 cellar: :any,                 ventura:        "b3536a6c3969c52b6eb8716eb7ed827ec2d5bd7661821151bc378b97d96ef18c"
    sha256 cellar: :any,                 monterey:       "543cdf04c1517054e74412709f34da1c22c888d5d8d2a6b4debab8d14e1e07be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8fec3b38c7e4d6fa520947d7580f4b30cc7ed09b31d722755b384955db5caf6"
  end

  # `cmake` is used to build `zlib`.
  # upstream issue, https://github.com/rust-lang/libz-sys/issues/147
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "zstd"

  def install
    ENV["ZSTD_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args

    man1.install "docs/onefetch.1"
    generate_completions_from_executable(bin/"onefetch", "--generate")
  end

  test do
    system "#{bin}/onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    (testpath/"main.rb").write "puts 'Hello, world'\n"
    system "git", "add", "main.rb"
    system "git", "commit", "-m", "First commit"
    assert_match("Ruby (100.0 %)", shell_output("#{bin}/onefetch").chomp)
  end
end
