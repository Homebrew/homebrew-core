class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "http://lfe.io/"
  url "https://github.com/rvirding/lfe/archive/v1.3.tar.gz"
  sha256 "1946c0df595ae49ac33fe583f359812dec6349da6acf43c1458534de3267036b"
  head "https://github.com/rvirding/lfe.git", :branch => "develop"

  bottle do
    sha256 "43a6e8bc1ff565e9e9c738f4b91ab689e8b9571dad53a7ff44158553fb9491aa" => :sierra
    sha256 "6bdbd8d5c785775f5f30872ed3d154d9b26a9135dc076688b35d6aba7f6967ff" => :el_capitan
    sha256 "5c28efffc677617959a383bd2eed80d226fa81c44ca368a0b9fc13aca8b7b1d1" => :yosemite
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
