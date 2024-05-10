class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://github.com/o2sh/onefetch/archive/refs/tags/2.21.0.tar.gz"
  sha256 "a035bc44ef0c04a330b409e08ee61ac8a66a56cb672f87a824d4c0349989eaf2"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3581ef45dadca882bb57a085849fd2ec9ba44c62d677c5ab08d5944a2f4d8a1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ca90fce57dc18ff55389d3567e3eba0a666a1d3e1c2f52b6bfe810889e6a19c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a091696f43ba20b0a0ba4abcce19d62be22e56782979490c18b8c8f6e733d61"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bcfdcded391edaecc787c5f1165116cbe194e466ae97c67bd3e3dbe7ee0ed95"
    sha256 cellar: :any_skip_relocation, ventura:        "481eeab95ebd1df96337c4027ea5a5222609353958ea1ab906828fd076f5f6cf"
    sha256 cellar: :any_skip_relocation, monterey:       "3c7f7278fd8a8ab9f36dbb6df6a8c49101bf9dd3f130c2989928c5d44ed404ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "263294e626cc159116127e22f45443035721cbd2b70f9c81eb7c1b9b633ebdaa"
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
