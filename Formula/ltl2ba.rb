class Ltl2ba < Formula
  desc "Translate LTL formulae to Buchi automata"
  homepage "https://www.lsv.ens-cachan.fr/~gastin/ltl2ba/"
  url "https://www.lsv.ens-cachan.fr/~gastin/ltl2ba/ltl2ba-1.2b1.tar.gz"
  sha256 "950f304c364ffb567a4fba9b88f1853087c0dcf57161870b6314493fddb492b8"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6a19718cf7ed4c57fa938520fc5fa2fc02239cc35b55e21e77c27f3ac4b0e586" => :catalina
    sha256 "754dd15206872409b2af919b68dfc65a30d6343ba31aead8a8db16416af9f916" => :mojave
    sha256 "9d1e6e9bca1073e604a7aa1e693c2df5a0636c8e6a5b82f85db491929520ae1b" => :high_sierra
    sha256 "151f207ca2627b0916371b49918f3b97174f5c2bab56abab0eb11d17d604037d" => :sierra
    sha256 "45916a60bb32849e1bc3709d019dcf6ac9d140d92e6f6b65bb5ca05de5c63e3b" => :el_capitan
    sha256 "d4c93b1f70b126540dae9d77e16f7e0b42e58ff1997fce63f51820621693588d" => :yosemite
    sha256 "75c0b88b4be2658bc02feb02214f833f7b27758381924b3e3a742ee9309579f6" => :mavericks
  end

  def install
    system "make"
    bin.install "ltl2ba"
  end
end
