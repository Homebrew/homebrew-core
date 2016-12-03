class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "http://lfe.io/"
  url "https://github.com/rvirding/lfe/archive/v1.2.1.tar.gz"
  sha256 "1967c6d3f604ea3ba5013b021426d8a28f45eee47fd208109ef116af2e74ab23"
  head "https://github.com/rvirding/lfe.git", :branch => "develop"

  bottle do
    sha256 "34db1c733113d753278a30046da6a2dd1f6d9681880ad456abfe392b64506c9f" => :sierra
    sha256 "6e9d0e8c471e57009658f2ea18bd7e60e20fe3c1892240e3df2ba53dac2812a0" => :el_capitan
    sha256 "ace4bea3a112b20507a58c11afe8e14111168a846cfa3c05788163e29f3e34ff" => :yosemite
  end

  depends_on "erlang"

  def install
    system "make"
    system "make", "MANINSTDIR=#{man}", "install-man"
    system "make", "emacs"
    libexec.install "bin", "ebin"
    bin.install_symlink (libexec/"bin").children
    doc.install Dir["doc/*.txt"]
    pkgshare.install "dev", "examples", "test"
    elisp.install Dir["emacs/*.elc"]
  end

  test do
    system bin/"lfe", "-eval", '"(io:format \"~p\" (list (* 2 (lists:foldl #\'+/2 0 (lists:seq 1 6)))))"'
  end
end
