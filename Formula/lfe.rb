class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "http://lfe.io/"
  url "https://github.com/rvirding/lfe/archive/v1.3.tar.gz"
  sha256 "1946c0df595ae49ac33fe583f359812dec6349da6acf43c1458534de3267036b"
  license "Apache-2.0"
  head "https://github.com/rvirding/lfe.git", branch: "develop"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c57baaef29be1d30231cbc3ff14c4ee103c89bcd86f1b09eb8cd43f8bc9e8dc6" => :catalina
    sha256 "d0fd48d72bf02ce31f39aabd5c7ec89aa4bb7f22f7bee979419ba59eabf0bbf5" => :mojave
    sha256 "ef0d47df833ea4c17bb07e1287129bb8bebbc870dfffe09b5f4a6f7875ccea52" => :high_sierra
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
