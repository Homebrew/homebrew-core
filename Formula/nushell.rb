class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.21.0.tar.gz"
  sha256 "24598bcf6e61825fd3b6f17e083952926a4b072efff413748bbd5bc83a3158f1"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url "https://github.com/nushell/nushell/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "2bcc8ec3f2836411772141f0b903e9a9102d582631e1b78e91f686c651ca93a8" => :catalina
    sha256 "6fd2a4b2dfab22998a9238812448627262e3ea594883f57676acae4d1509ff39" => :mojave
    sha256 "91c09422af2e637d33eb59bfdac0c5b950cb3d4f6e57653c233109853b1bb0d7" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--features", "stable", *std_cargo_args
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar" : "homebrew_test"}\' | from json | get bar')
  end
end
