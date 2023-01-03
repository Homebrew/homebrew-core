class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "https://lfe.io/"
  url "https://github.com/lfe/lfe/archive/v2.1.0.tar.gz"
  sha256 "5554f9fec066963a6d79c8cd5f6b6eff0d1f0397425331fd88dcae9907756b66"
  license "Apache-2.0"
  head "https://github.com/lfe/lfe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab1ebda0a11eae1ac2f12f33d7ffdbf119db51582ea2ec631c6c505cf9147013"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37df9827bf1c4652dc1bf580189d858b710eba37c411c86356a3284e4e4a21e7"
    sha256 cellar: :any_skip_relocation, ventura:        "009a77d5e1e12ed074a4d4077e1f2d6dd7b4f9341e865eb938f3664691532042"
    sha256 cellar: :any_skip_relocation, monterey:       "5a884633e2e5ba246256acb584ab0e984bb8b2fa806e2d717397a031cd795772"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e7ccd17a1e88c32b63defbaee55f314b48c3833f7b04638ba7da9557519c1ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3bb17753cd2332c3a10ae24c24b7effd60e2db32bb7e97793c643410b70c619"
  end

  depends_on "emacs" => :build
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
