require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.6.28.tar.gz"
  sha256 "02ef2018d73c98608340146701a7e8c84e629732487fc9dab172d770d426e350"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    cellar :any
    sha256 "b030a59a21df9915712bd26ce07b6432153fd6bb4eade27d9b7dcf4b5914258f" => :mojave
    sha256 "a20cf59639012dcc241fa03944d4761f25bc44d1ba3787a734c2c536ddc02c80" => :high_sierra
    sha256 "a13e9cfb33930c0569befd0fdfa70e38b523b526e98847a6adfa8e137461c791" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
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
