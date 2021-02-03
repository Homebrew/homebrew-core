class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.26.0.tar.gz"
  sha256 "66fbfe1297997a3f6b2181cd723816150ad2453527c7cab6c83a9c67b9af2478"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "34500e7bd0ca8a0cd8e187ade89a81b7beb372b1715337f17111c4e1acfd99f6"
    sha256 cellar: :any_skip_relocation, big_sur:       "05d199ea12d531abc34548b808d0701ff14d00a986481f9ae8f1776dac765c8c"
    sha256 cellar: :any_skip_relocation, catalina:      "82e2ed4ad465d0bf59a6d2cd042ebd6b51e0da46d32d4df4d0a7d091b5b4a16a"
    sha256 cellar: :any_skip_relocation, mojave:        "06683151d468a8fbe3dac4fafb9a2133b48e832cf7555fe78e06bc7096e95e3f"
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
