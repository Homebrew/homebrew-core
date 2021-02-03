class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/0.8.1.tar.gz"
  sha256 "745ae0f47bdfcae729666b2944ffaaf795e1c3a685f7fb742f361fcbc0232d31"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6191e4fbf60755b03d4e89974ddf800fa3483975dedfd723a6220987929ada5b"
    sha256 cellar: :any_skip_relocation, big_sur:       "be3e05a183786c6ed689f5afa0bc330027a98283f36b276a5f8dd268f5f698db"
    sha256 cellar: :any_skip_relocation, catalina:      "601195ccdc73d0c999e6dd6a759f0791016624c322b360ed1367a97f8ffb382d"
    sha256 cellar: :any_skip_relocation, mojave:        "5639d69a8da9dd7a422a73685d863d8bd8326f75e96f70c58abcc3b5a2e60ed4"
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
