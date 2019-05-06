class Cltl < Formula
  desc "Common Lisp the Language v2"
  homepage "https://www-2.cs.cmu.edu/afs/cs.cmu.edu/project/ai-repository/ai/lang/lisp/doc/cltl/"
  url "https://www-2.cs.cmu.edu/afs/cs.cmu.edu/project/ai-repository/ai/lang/lisp/doc/cltl/cltl_ht.tgz"
  version "2"
  sha256 "6692b1519abca379b42f62d7db6065dc0103105bb021dfee581469546174324a"

  bottle :unneeded

  def install
    doc.install Dir["*"]
  end

  test do
    assert_predicate doc/"cltl2.html", :exist?
  end
end
