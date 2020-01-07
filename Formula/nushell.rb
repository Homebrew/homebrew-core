class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.8.0.tar.gz"
  sha256 "fada2e350efdf0e730469ab503499b76ab97326bf6e8fc7ffc5db99a4c311ce6"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "832c8447b349172f497612d7a6dfad41fe0bde9510d96bf51ad649998c4bf5b1" => :catalina
    sha256 "328b14e7636e4645720fb5f2e223ec4fa0199f4c59e569e1f6b08499e93d1d94" => :mojave
    sha256 "bb91fa56f066f0e39cbcf67f70073d20b9857f22bc09a8467bad2145a777585d" => :high_sierra
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
