class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.43.0.tar.gz"
  sha256 "6b502c66a359d3f393cbe342fda3fa301ed517e9a52b3f79e4949aada4135bc8"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c2ded45af86683a520e75c0f14ed339d1d3f7630256b55f57ce85f7ff3471a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb7b0549d759e51d21b3ba7f5c3bafa30ae77bf92265af6f285248775fa3a0e0"
    sha256 cellar: :any_skip_relocation, monterey:       "98cf31575b5ca7cc53fa540bcbda65a66b798c6b28b6994d8eb86d2fda7770fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fad4f7f948e4704c548064888bdcbf2ae49a4248af156a0d52214e41649a6ab"
    sha256 cellar: :any_skip_relocation, catalina:       "df607a6390a4ba30612c421da557a9958182d441d3b9a2ea43045c97d8e43977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "443905a5217537bed82d8244517363b7cc54d5c559d03175c6e807979f69b343"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "extra", *std_cargo_args
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar" : "homebrew_test"}\' | from json | get bar')
  end
end
