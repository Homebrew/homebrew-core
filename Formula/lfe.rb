class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "http://lfe.io/"
  url "https://github.com/rvirding/lfe/archive/v1.2.0.tar.gz"
  sha256 "0abc6e95e3ccb3eff2bc323418e6a095fbdeee7750e12f9f76c67c69d6558e17"
  head "https://github.com/rvirding/lfe.git", :branch => "develop"

  bottle do
    sha256 "34db1c733113d753278a30046da6a2dd1f6d9681880ad456abfe392b64506c9f" => :sierra
    sha256 "6e9d0e8c471e57009658f2ea18bd7e60e20fe3c1892240e3df2ba53dac2812a0" => :el_capitan
    sha256 "ace4bea3a112b20507a58c11afe8e14111168a846cfa3c05788163e29f3e34ff" => :yosemite
  end

  depends_on "erlang"

  # Prevents build failure "Error in process <0.49.0> with exit value ..."
  # Reported 18 Oct 2016 in PR "Fix parallelized builds"
  patch do
    url "https://github.com/rvirding/lfe/pull/292.patch"
    sha256 "966db8bc444273f3a790c7eaa0b35c7c8d0a407d5c2c3039674f1c4d9ab5a758"
  end

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
