class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://github.com/o2sh/onefetch/archive/refs/tags/2.20.0.tar.gz"
  sha256 "385bc8f11c3e1cf168ef6d4c64263ded44af948184a990611c1b30fe6c46e37e"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb296ff6fca01d76872a84d7c4f2b7fae57e2f12ad065ae04cd78ab7df45642e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd6aca6f2f80ce4938871fc5df1e49ab7a2d0be5cbdb2625a27b052db1563e80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55fce6fc7a01c92a8d191337e4c6a53002f24783894a846b74a70212fe31ece6"
    sha256 cellar: :any_skip_relocation, sonoma:         "84dc41bd1bb83635b80c2eb02cfb221f3664de0ce51d944a17162ef258ab5043"
    sha256 cellar: :any_skip_relocation, ventura:        "cdafeaacedc82fbe0407c3579b3c7c0aa43757754749ed0cfbd5f6e75dce42a9"
    sha256 cellar: :any_skip_relocation, monterey:       "7c5d9fb64addd326eb9da06de65dce02bab55fb3a4fd4092fec618588081f7f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba5cb1aa3658f10a11b2e40910564d108410b6d4f7c9a4ef5bac6be8fd0089ae"
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
