class Cfonts < Formula
  desc "Sexy ANSI fonts for the console"
  homepage "https://github.com/dominikwilkowski/cfonts"
  url "https://github.com/dominikwilkowski/cfonts/archive/refs/tags/v1.1.1rust.tar.gz"
  sha256 "f7d9ef5ce4f19ac214c122c8fc0e0382eb5fa000e53bbc30f3c74f138dc217ed"
  license "GPL-3.0-or-later"
  head "https://github.com/dominikwilkowski/cfonts.git", branch: "released"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)[._-]?rust$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edddb8d2de2f23efa697ad9ed7acca496d6128f9e8b5ec62d11c40b96c74f995"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6994a1c64a87e5def25a7dabed539b698e9d5d7674a238a4ef0f7c601e2a4ebc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ba18673cedf2dc92e4963e8a56626251b84604751fe1877fc879f70ff24af0e"
    sha256 cellar: :any_skip_relocation, ventura:        "e5991ee2bfd3324e787535b8533aa91fa45b66163f059f8ed5da5fd20de099e8"
    sha256 cellar: :any_skip_relocation, monterey:       "52ebaf310116a61341c46450e221dace609b984ad9d18046a5f59f1e62921bec"
    sha256 cellar: :any_skip_relocation, big_sur:        "195abb0316d11a1cd43100846bdd8dc21e0a27ed68c6d294d6ed0305586c8864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6941cb766fedc2b3eb2131cfbc237718214dbb448c89624de30fb0df32d6704e"
  end

  depends_on "rust" => :build

  def install
    chdir "rust" do
      system "make"
      system "cargo", "install", *std_cargo_args
      bin.install "target/release/cfonts"
    end
  end

  test do
    system bin/"cfonts", "--version"
    assert_match <<~EOS, shell_output("#{bin}/cfonts t")
      \n
       ████████╗
       ╚══██╔══╝
          ██║  \s
          ██║  \s
          ██║  \s
          ╚═╝  \s
      \n
    EOS
    assert_match "\n\ntest\n\n\n", shell_output("#{bin}/cfonts test -f console")
  end
end
