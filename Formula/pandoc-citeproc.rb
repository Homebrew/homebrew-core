require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.14.2/pandoc-citeproc-0.14.2.tar.gz"
  sha256 "853f77d54935a61cf4571618d5c333ffa9e42be4e2cccb9dbccdaf13f7f2e3b7"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "0d708ce22009e1562d55bb47edd0bcf4605d6840e9468dc7ff775899ec3ca7f6" => :high_sierra
    sha256 "fb8a8bd02cc81f752c5c1f4e92de7aea7ab12d0491cf957adaed1c99f9952d94" => :sierra
    sha256 "22e94ac80d6e00fadccddd8110b90c2a47450d1452866677582d38b2aaf9eefb" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  def install
    args = []
    args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion

    # Remove pandoc-types constraint for pandoc > 2.1.2
    # Upstream issue from 13 Mar 2018 "Pandoc 2.1.2 failed building with GHC 8.2.2"
    # See https://github.com/jgm/pandoc/issues/4448
    install_cabal_package "--constraint", "pandoc-types < 1.17.4", *args
  end

  test do
    (testpath/"test.bib").write <<~EOS
      @Book{item1,
      author="John Doe",
      title="First Book",
      year="2005",
      address="Cambridge",
      publisher="Cambridge University Press"
      }
    EOS
    expected = <<~EOS
      ---
      references:
      - id: item1
        type: book
        author:
        - family: Doe
          given: John
        issued:
        - year: 2005
        title: First book
        publisher: Cambridge University Press
        publisher-place: Cambridge
      ...
    EOS
    assert_equal expected, shell_output("#{bin}/pandoc-citeproc -y test.bib")
  end
end
