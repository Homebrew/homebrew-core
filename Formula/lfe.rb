class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "https://lfe.io/"
  url "https://github.com/rvirding/lfe/archive/v1.3.tar.gz"
  sha256 "04634f2c700ecedb55f4369962837792669e6be809dba90d81974198fc2b7b72"
  license "Apache-2.0"
  head "https://github.com/rvirding/lfe.git", branch: "develop"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "26ac196800954a35b70ff8b1244f8d62e9f8f4cd29b312743e3026e5407745b3" => :big_sur
    sha256 "056b4f7b13b58355e0b8b24a6fc192bcb6da3fa69b599f366eabc17ea4c5eefb" => :arm64_big_sur
    sha256 "7dd076c48d565d4d0b686224178c1ee98a121529544633af3b13c71565f1f9e5" => :catalina
    sha256 "f05f9f0affc3bba078432f5822f85549ea905ce0dc4271f501e0d38e113dd09f" => :mojave
    sha256 "4a2aff7e038f97050cbd8beb84023c9c9c093078ba4233ead520513bd708b3c5" => :high_sierra
  end

  depends_on "emacs" if MacOS.version >= :catalina
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
