require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.6.24.tar.gz"
  sha256 "0958549a6d1989abad493845b788dd67bf65a50162393deedf8738dbc7f3a7cd"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    cellar :any
    sha256 "f3468796fdaf43c65bb77d2fc3eb376b434743225b555e235aea01ffd24f2ed6" => :high_sierra
    sha256 "01a5cca60e69cdbc82bcb8e7923eb7ea9a18ee7f95eee94523d44171ba79da64" => :sierra
    sha256 "07e0201c1c2ef9b0c820d518987f8c56552eb5748002e9c2f57afd2322396d2a" => :el_capitan
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pcre"

  def install
    install_cabal_package
  end

  test do
    (testpath/"t.rb").write <<~EOS
      # puts test comment.
      puts "test literal."
    EOS

    assert_match ":1", shell_output("#{bin}/cgrep --count --comment test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --literal test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --code puts t.rb")
    assert_match ":2", shell_output("#{bin}/cgrep --count puts t.rb")
  end
end
