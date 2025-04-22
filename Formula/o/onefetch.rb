class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://github.com/o2sh/onefetch/archive/refs/tags/2.24.0.tar.gz"
  sha256 "41f457c9a8145de94980bcae497d84a56cd75c1598a6a9eeb45984947bf4f1f8"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c79034fef2b28abfb613dab6543eef17e6af769c95757166f1f727d37d5a42e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c710fccdd294242271b24039e0fa3061a31e5dbbf51284c76f5787cdafc576a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d5b20ed5411fe25cb11826d296747c450106ec05a39c75f4aaa4c02e4270413"
    sha256 cellar: :any_skip_relocation, sonoma:        "abaf9ef77c37013d923120998bf635fef83a9306c49a4cef33e6d8b52abb5d8b"
    sha256 cellar: :any_skip_relocation, ventura:       "282e6231286ee1202b43383ad6fb4c204fe7f74dd8cc8d105e11615f1c455118"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4aa3c84ab3e60e49ef85ba76bb5de32fdf3d9cc0deaf31e8457accdd740d6a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b5b8a5b8b13919f6d912ac00b3ddeeddca5efe0b0a721deabfba8a024b57106"
  end

  # `cmake` is used to build `zlib`.
  # upstream issue, https://github.com/rust-lang/libz-sys/issues/147
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "zstd"

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
