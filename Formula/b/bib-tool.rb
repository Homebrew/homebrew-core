class BibTool < Formula
  desc "Manipulates BibTeX databases"
  homepage "https://www.gerd-neugebauer.de/software/TeX/BibTool/en/"
  url "https://github.com/ge-ne/bibtool/releases/download/BibTool_2_68/BibTool-2.68.tar.gz"
  sha256 "e1964d199b0726f431f9a1dc4ff7257bb3dba879b9fa221803e0aa7840dee0e0"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^BibTool[._-]v?(\d+(?:[._-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:    "21dc870e5436946a79ee212b44a1d867c872f5c2374a3693563097dd89212849"
    sha256                               arm64_sequoia:  "ce609aa4354f5b345611a48f17823affc614c23600940ec1c90b9945b7199512"
    sha256                               arm64_sonoma:   "20a1020682e98e6b692a2096aea9d9963c6294f12c810ce0aa9135ca26bf6da1"
    sha256                               arm64_ventura:  "7cb1325a01c1b3516c543d5911f0b10eeb6e68df2abe4b3541ff68242ffc356e"
    sha256                               arm64_monterey: "d9e9e76159ba4398731428fd7ab2523d9066c325b28efc7b6012b5e9784bfd95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56f39057fc8ab04a9f3e2a05ba7ad58a01bd73b66dcd50715ea8c492afaffc7e"
    sha256                               sonoma:         "9b04230870283c0bbb78a8abbc3c805bcb3ba5df1e713c98f57e39ace29ec4b5"
    sha256                               ventura:        "6ab04c4b9cc2400c1e0239654e1ee02487b545e497597eae58d20cdef1a9448e"
    sha256                               monterey:       "552d9e005a5e6362efac8d592fd26bfa2669651776a2ec95ee0a9dd32c6854d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2c2aafbf6a019096510776591956f8114489eff19cb46578dc33f1ea85401d5"
    sha256 cellar: :any_skip_relocation, catalina:       "26f2121d720fa6ffc20547b0bfc6754930f6b8660b51f634c686279dae7e73ce"
    sha256                               arm64_linux:    "950aa4606e27f585b5845def489fa649687dcbfa927b7ceb79d2186c7c0e5cfc"
    sha256                               x86_64_linux:   "26d038986c5f22a7fd14898391052bd93ac18d34374c2662624efd50ff86a137"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--without-kpathsea"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.bib").write <<~BIBTEX
      @article{Homebrew,
          title   = {Something},
          author  = {Someone},
          journal = {Something},
          volume  = {1},
          number  = {2},
          pages   = {3--4}
      }
    BIBTEX

    system bin/"bibtool", "test.bib"
  end
end
