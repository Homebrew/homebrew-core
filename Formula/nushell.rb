class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.32.0.tar.gz"
  sha256 "57cbd6cbbc9a3d2f8b99942486410e003487be0faabd275e87ab77342a8c0989"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3b639153601db907dd1a19f16faf6c0f584fa23cb28617258376a19093095f03"
    sha256 cellar: :any_skip_relocation, big_sur:       "1019482f62d50bf08a4b678cb799f7cfa250f0113bda561f592783541d38cb97"
    sha256 cellar: :any_skip_relocation, catalina:      "6cdf4b8457bf4a52301ef997edb466051a08436f95754e58c5a66d445dd345ed"
    sha256 cellar: :any_skip_relocation, mojave:        "37ae10efae623ad60bb1cc5931d6b1c7f73e7cfdc95ff649105ee78744664544"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--features", "extra", *std_cargo_args
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar" : "homebrew_test"}\' | from json | get bar')
  end
end
