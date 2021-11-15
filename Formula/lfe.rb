class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "https://lfe.io/"
  url "https://github.com/lfe/lfe/archive/v2.0.1.tar.gz"
  sha256 "d64a5c0b626411afe67f146b56094337801c596d9b0cdfeabaf61223c479985f"
  license "Apache-2.0"
  head "https://github.com/lfe/lfe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0545632700f2ff959dbb62551efd7f0ea168d1ed839af42465c957f3871028e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4bd4da0c02fc08e5b326b7cdea041e9e4daef7eb767cfd9b06b2a4777344c6b"
    sha256 cellar: :any_skip_relocation, monterey:       "c911ba164288b5fa4b800d33630a7f6709d473ba5aeff263f34b3713f90022c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b1a15cdc71cf54af9cf00b044694dbfe00b603d4caf3060ac1f904a95304290"
    sha256 cellar: :any_skip_relocation, catalina:       "8b6707bd8f4d0e7154d732e261001276efda9ec89f24a965ef25a8e5dfeda61a"
    sha256 cellar: :any_skip_relocation, mojave:         "774edd008cb45c6496247bcebb7370dee9555ea72563d90c5c42da23595b2b03"
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
