class PandocCiteproc < Formula
  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.17.0.2/pandoc-citeproc-0.17.0.2.tar.gz"
  sha256 "0b8846ca37547004a6a165ff7f47f58a07f783b01da32c8bf5740272fe37e1f2"
  license "BSD-3-Clause"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "518ed9646d3a165b413a4222d87d5148130891fc2505f2e71e20e05507131992" => :catalina
    sha256 "fbbe846a5843e8e0de7d7bafa3ff3af2600c4fbb8ee2e50a05286ac02de52f6e" => :mojave
    sha256 "dfd25614701ee6cfdbe4ec0d6e67a9e54f6c08ded7f8b3de65f1db621fdc72dc" => :high_sierra
  end

  # https://github.com/jgm/pandoc-citeproc/commit/473378e588c40a6c3cb3b24330431b89cf4f81b4
  # This package is no longer maintained.
  # Pandoc now uses the [citeproc](https://github.com/jgm/citeproc)
  # library, and no external filter is needed.
  disable! date: "2020-10-09", because: :deprecated_upstream

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
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
