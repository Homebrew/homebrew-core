class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "http://lfe.io/"
  url "https://github.com/rvirding/lfe/archive/v1.2.0.tar.gz"
  sha256 "0abc6e95e3ccb3eff2bc323418e6a095fbdeee7750e12f9f76c67c69d6558e17"
  head "https://github.com/rvirding/lfe.git", :branch => "develop"

  bottle do
    sha256 "90e27865811195327a873e8a1738be15c1689d282ad7a53534d513f3a8d383c3" => :sierra
    sha256 "8a6adf72bf5d51ec031aeccfeef5b3f07a829a959ef238f0a01e4d2cee3fb0b8" => :el_capitan
    sha256 "68bed24455801df91738dce5a0da2162d179e0b4569bb03a88bc468621d05b64" => :yosemite
    sha256 "63bbc993e6c35f61bed6376f1660ace93a08a59169e7fe907b7688d5bdf96808" => :mavericks
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
