class Chawan < Formula
  desc "TUI web browser with CSS, inline image and JavaScript support"
  homepage "https://sr.ht/~bptato/chawan/"
  url "https://git.sr.ht/~bptato/chawan/archive/v0.4.2.tar.gz"
  sha256 "95e0ee09df7ab328c9c366a3ac73155d8bafd43cde9096cd1cd86d3bdf52e880"
  license "Unlicense"
  head "https://git.sr.ht/~bptato/chawan", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "742feccbb60b2faca1a71120955fcdc4f929c3b1825e1821706ec27a60444eb2"
    sha256 cellar: :any, arm64_sequoia: "9d57d0ab7b86b46f8b0389be5dad307368021e788e26bfe6d897079841abb2ef"
    sha256 cellar: :any, arm64_sonoma:  "d957fdb16189ef5bd33feb113326fdb79c249a15a461bc9bfcc37ed2e324f33a"
    sha256 cellar: :any, sonoma:        "e340d12b31173a1de3866400f9f3bb5463d7e06f457714e579254515ee53b7a2"
    sha256 cellar: :any, arm64_linux:   "53c4476f7505030541849a1491bcf1054239233107192164ac767fdf77169610"
    sha256 cellar: :any, x86_64_linux:  "616f67fa6652ca81df86705b8bf85a6a78097f2371a93b7e05707a795e3823bf"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build

  depends_on "brotli"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cha --version")
    assert_match "Example Domain", shell_output("#{bin}/cha --dump https://example.com")
  end
end
