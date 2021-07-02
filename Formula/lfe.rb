class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "https://lfe.io/"
  url "https://github.com/lfe/lfe/archive/v2.0.1.tar.gz"
  sha256 "d64a5c0b626411afe67f146b56094337801c596d9b0cdfeabaf61223c479985f"
  license "Apache-2.0"
  head "https://github.com/lfe/lfe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7745910e18ebc4dd084e5c39a77e09d423ade2f9b89f84cdfccad58b9a80a22e"
    sha256 cellar: :any_skip_relocation, big_sur:       "1cbcf0bc43a850e7f57ec9d9447a5bf4c1047aac0d7e2df89f51b169969ed599"
    sha256 cellar: :any_skip_relocation, catalina:      "e2f25a22dc8d4f3feb6212222d19525779bf424a9e88ae15cfa9fb3cae3c5d1a"
    sha256 cellar: :any_skip_relocation, mojave:        "d95f508c8a023d77e8e3f3b8f84434c0282b9279cca2fd478c172c2ee1214b2b"
  end

  depends_on "emacs" => :build if MacOS.version >= :catalina
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
