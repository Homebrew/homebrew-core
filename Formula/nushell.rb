class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.8.0.tar.gz"
  sha256 "fada2e350efdf0e730469ab503499b76ab97326bf6e8fc7ffc5db99a4c311ce6"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ef158b90a9aafef35f6885cfbc843eaee29fcbfd098337c9a9d0bbcfd31d69e" => :catalina
    sha256 "3a4056fd7d2867f279ab8e77906b68728c87d309423bbd212eb5cea80feb6bd7" => :mojave
    sha256 "c87c8fb6585391bc62c33af07c52452def5b3329c7f408f07da3bc8dbcecb63a" => :high_sierra
  end

  depends_on "rust" => :build

  depends_on "openssl@1.1"

  def install
    system "cargo", "install", "--features", "stable", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "\n~ \n❯ 2\n\n~ \n❯ ", pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it')
  end
end
