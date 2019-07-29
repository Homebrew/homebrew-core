class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "http://lfe.io/"
  url "https://github.com/rvirding/lfe/archive/v1.3.tar.gz"
  sha256 "1946c0df595ae49ac33fe583f359812dec6349da6acf43c1458534de3267036b"
  head "https://github.com/rvirding/lfe.git", :branch => "develop"

  bottle do
    sha256 "3b141e0c7c6d6630883e0ed5a00590e4e5b868fc1817b99c62afaccc4cb361dd" => :mojave
    sha256 "1a0f582845e8c0c87331c9e9148b06dde79483847cc1bb31674596fe2d3c3422" => :high_sierra
    sha256 "a6f27b9dd837d866fb471db3556677112c4f8ca3df386596f975083a939c8a16" => :sierra
    sha256 "47827019926bdbfb6b0fa0c7fe123b0007482670aa651408e736f00c4796ce01" => :el_capitan
    sha256 "aab3e33761e9db3c4e5cceb8769edca70f2eb618e0bed5e3658ab2fdc3bae2ac" => :yosemite
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
