class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.23.0.tar.gz"
  sha256 "fbb490fa25cb4ca6ec46b33274ee8a222407a1786dd2204f05ceb573eb0246aa"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "d4e14e0b8effc741f32b1a2a64a0db0524cbe6a713c4f4bc7a51357c5498d448" => :big_sur
    sha256 "5741c03985869393fd9d3e9767e131dacc9ae0bd00a29bf404edf805c9189a90" => :catalina
    sha256 "2883a545dfe805e09d5f73c20da9f0d4893d0729d217a396d19e9f9ee07afad8" => :mojave
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
