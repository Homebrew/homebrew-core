class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.18.1.tar.gz"
  sha256 "68761a9145630199df16ccb39225acd58c19c8773aaa79ab5eb1674ff694ca79"
  license "MIT"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "637a8f1a243640b4f88ff510757a14a05863789deec5f369f72ad5f2ecd9997c" => :catalina
    sha256 "4cc71973703b022332cdd71f5ba1ace11d27388b0c3daa8489b26cb4e6aafc76" => :mojave
    sha256 "ff803c46885adef74139fcf27c7403555bb51908363565e0fc4ff23b1dd27119" => :high_sierra
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
