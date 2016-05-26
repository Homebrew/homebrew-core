require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing."
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.2.1.3/pandoc-crossref-0.2.1.3.tar.gz"
  sha256 "d14b78972c48a722b7e53d12fb601e4379d5384f9a58c8ce46ab42b058125471"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "1304c1dcf8e5dc1bd288f861d98916b3a759c7f9e008f44bbb03593efe24e267" => :el_capitan
    sha256 "0a2a6f28222868d423aaacbd3df905de3f87360585bb291027f5ef1a1a0ea926" => :yosemite
    sha256 "df8fd772d34668fbc7437731b61fb26bc37cc6a706922f3bb5080abe95e553f1" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc" => :run

  def install
    cabal_sandbox do
      # GHC 8 compat
      # Reported upstream 26 May 2016: https://github.com/lierdakil/pandoc-crossref/issues/69
      # For specifics regarding the API changes, see
      # https://ghc.haskell.org/trac/ghc/wiki/Migration/8.0#template-haskell-2.11.0.0
      # http://git.haskell.org/ghc.git/commitdiff/575abf42e218925e456bf765abb14f069ac048a0
      inreplace "lib/Text/Pandoc/CrossRef/Util/Settings/Template.hs" do |s|
        s.gsub! "DataD _ _ params cons' _", "DataD _ _ params _ cons' _"
        s.gsub! "NewtypeD _ _ params con' _", "NewtypeD _ _ params _ con' _"
        s.gsub! "VarI _ t' _ _ <- reify accName", "VarI _ t' _ <- reify accName"
      end
      (buildpath/"cabal.config").write <<-EOS.undent
        allow-newer: base,time
        constraints: data-accessor-template ==0.2.1.12
      EOS
      system "cabal", "get", "data-accessor-template"
      cd "data-accessor-template-0.2.1.12" do
        inreplace "data-accessor-template.cabal",
          "Build-Depends:  template-haskell >=2.4 && <2.11",
          "Build-Depends:  template-haskell >=2.4 && <2.12"
        inreplace "src-5/Data/Accessor/Template.hs" do |s|
          s.gsub! "DataD _ _ params cons' _ -> return (params, cons')",
            "DataD _ _ params _ cons' _ -> return (params, cons')"
          s.gsub! "NewtypeD _ _ params con' _ -> return (params, [con'])",
            "NewtypeD _ _ params _ con' _ -> return (params, [con'])"
        end
      end
      cabal_sandbox_add_source "data-accessor-template-0.2.1.12"

      args = []
      args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
      install_cabal_package *args
    end
  end

  test do
    (testpath/"hello.md").write <<-EOS.undent
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \sum_i a_i x^i $$ {#eq:eqn1}
    EOS
    (testpath/"expected.txt").write <<-EOS.undent
      <p>Demo for pandoc-crossref. See equation eq.M-BM- 1 for cross-referencing. Display equations are labelled and numbered</p>$
      <p><br /><span class="math display"><em>P</em><sub><em>i</em></sub>(<em>x</em>)=<em>u</em><em>m</em><sub><em>i</em></sub><em>a</em><sub><em>i</em></sub><em>x</em><sup><em>i</em></sup>M-bM-^@M-^AM-bM-^@M-^A(1)</span><br /></p>$
    EOS
    system Formula["pandoc"].bin/"pandoc", "-F", bin/"pandoc-crossref", "-o", "out.html", "hello.md"
    assert_equal File.read("expected.txt"), pipe_output("/bin/cat -et", File.read("out.html"))
  end
end
