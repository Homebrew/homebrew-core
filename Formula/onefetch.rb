class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/2.14.2.tar.gz"
  sha256 "df5e10aac076369bbbdeb94eef286dbde8d10859fd8f47af7e2748fadef0622c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2816a754cf2972ae244ace2110ebbcbbb044bcefceb21674a25020bbb7827ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8725bfcf273d01f0dca5430b9c50c87e16059e21f921de7a9dda6c6bed085095"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8da859e5948af25a63870f814ce442278abd64909df537e896a65a467ebcfe9e"
    sha256 cellar: :any_skip_relocation, monterey:       "a21243206b37e9be931d274fb01a9c9630bb46f6d1071c5fa22bd4ebdbbce4fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "6608a892fedb45f40169ba0ccbfba1bfd8ff75171b2bea6567fabc001cb55ec5"
    sha256 cellar: :any_skip_relocation, catalina:       "ad015341f3431b6a6e66c62595ca2a3623a7e4a2a359cc22dbbd66f77e92b26a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c9ce5ac73e355a5ca1d709871a8fbec4068ccccec67a3cc89deb6655fce362f"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
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
    system "echo \"puts 'Hello, world'\" > main.rb && git add main.rb && git commit -m \"First commit\""
    assert_match("Ruby (100.0 %)", shell_output("#{bin}/onefetch").chomp)
  end
end
