class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://github.com/o2sh/onefetch/archive/refs/tags/2.22.0.tar.gz"
  sha256 "1741516c628bb70b432285aa78439c4acfeb5df19e48b8d85dba5f71336e190b"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32543d9359bf4d51a16bb0697ab1f9eef7922f9735e443b784cd980caaddfdb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "413caa8752bdc098bde8f61cd443037367a1081e859260ec488d7396e780f820"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87f7705ba92328a8cb550761a1f28a40bb5bb45b3cde81eb57ffe50e664f8c85"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d7ec643430fe3b6253ffc108e7091a77dffd07b87099761b9101d334168f113"
    sha256 cellar: :any_skip_relocation, ventura:       "7e842546e35a7ba31a3636c5bd7583d2b29c48443443a76d22bbec3312a0c4d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d514014e3ddd400c50e57aecd7410e015a6bbc17eb93a16ec0e33ce8011ac63a"
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
