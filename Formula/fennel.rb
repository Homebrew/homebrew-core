class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/0.9.1.tar.gz"
  sha256 "1bf39419dd789d230401583509b74190e7309abf4cb1c14064e25e547758d6c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0788bd23559bd563680467e304418284cdd49ddab92163fd37dffb311dcf941a"
    sha256 cellar: :any_skip_relocation, big_sur:       "0f0b625343d03ec4bcf21f7e42713fa626f69c4c091e5759f371c07554fe0ed8"
    sha256 cellar: :any_skip_relocation, catalina:      "7ac0a1b970ae41dff3042920221c3ffd3fc60ca52a926f1f9efea76b43a6049d"
    sha256 cellar: :any_skip_relocation, mojave:        "dac8476bb6659b3c1b389c27de95e7792a993600a9c78ce2bd693c1701676622"
  end

  depends_on "lua"

  def install
    system "make", "fennel"
    bin.install "fennel"
  end

  test do
    assert_match "hello, world!", shell_output("#{bin}/fennel -e '(print \"hello, world!\")'")
  end
end
