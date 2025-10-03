class Greed < Formula
  desc "Game of consumption"
  homepage "http://www.catb.org/~esr/greed/"
  url "https://pkg.freebsd.org/ports-distfiles/greed-4.3.tar.gz"
  mirror "http://www.catb.org/~esr/greed/greed-4.3.tar.gz"
  sha256 "60433afaef3eb8e20e4aa33d4b5538f6ea661b1880c98cd9d7c6df86c91d4baa"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/greed.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7dd0a88d2965272e5c99454d0d94cb651ddb8379167b8ab7c796d4e94d146926"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a3e7b7239960308e29bf2dfe2e74e0c8d8f668eba481d83b64235180f96efbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa7e8531d206c50da08b2e675a362e6a456476d177af8d31135e65f900e1f673"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d5d9248e0afb74bf84489914b4db0076f3d2ebcaf673410ddfebbd3b29cae2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4bc754b53d564166bb70c838b7cf122c8d85d01482d6a6c6ce3d7dbddf37fdba"
    sha256 cellar: :any_skip_relocation, ventura:        "248414686a9fe19755be3b53a948dc70e4b81dd9bd9bde5939003d76999b6de7"
    sha256 cellar: :any_skip_relocation, monterey:       "20c9887c2d21ce3992fd41f9fac4ff26ff3152e06112ae408026d6c8987f5cbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a8a0ec247b8ec304b34ba794ba84953130b814a6506b7696b2800bf23d4e287c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7f7db5fc7dbc281817a928f614c13af17805c1e8b7804cef14b7cb23f5ac6cf"
  end

  deprecate! date: "2024-06-07", because: :checksum_mismatch
  disable! date: "2025-06-21", because: :checksum_mismatch

  uses_from_macos "ncurses"

  def install
    # Handle hard-coded destination
    inreplace "Makefile", "/usr/share/man/man6", man6
    # Make doesn't make directories
    bin.mkpath
    man6.mkpath
    (var/"greed").mkpath
    # High scores will be stored in var/greed
    system "make", "SFILE=#{var}/greed/greed.hs"
    system "make", "install", "BIN=#{bin}"
  end

  def caveats
    <<~EOS
      High scores will be stored in the following location:
        #{var}/greed/greed.hs
    EOS
  end

  test do
    assert_predicate bin/"greed", :executable?
  end
end
