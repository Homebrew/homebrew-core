class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "https://lfe.io/"
  url "https://github.com/lfe/lfe/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "19a51ad759a547c35535f8bbbafd982aab647ebfb15b438d233e4102fd8761a3"
  license "Apache-2.0"
  head "https://github.com/lfe/lfe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a8623073ae4695d71a1c6ebd25e33982f5919c8f8178674242ab160ee689fc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd4b14d7ed48b9e86067da8b52c5653954185a0ea9b20213b554ed285a0c0547"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a78872dfe049d0de66bfe02fa858a6fc5eac15537173e65b2c07fba5c7cdb0fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f626f1110b40eeca84aaef15e132d9772adf9b4c9735d7a68c482ecf109ca64"
    sha256 cellar: :any,                 arm64_linux:   "057c7083596b778c609a716850674d64ae64772a45ddf0cda46097a75db509bd"
    sha256 cellar: :any,                 x86_64_linux:  "48b60321d149efc7263596fbeb6536c03e7883e6002a73a4c9ba9a342b41d29e"
  end

  depends_on "emacs" => :build
  depends_on "erlang"

  def install
    system "make"
    system "make", "MANINSTDIR=#{man}", "install-man"
    system "make", "emacs"

    libexec.install "bin", "ebin"
    bin.install_symlink (libexec/"bin").children
    pkgshare.install "dev", "examples", "test"
    doc.install Pathname.glob("doc/*.txt")
    elisp.install Pathname.glob("emacs/*.elc")
  end

  test do
    system bin/"lfe", "-eval", '"(io:format \"~p\" (list (* 2 (lists:foldl #\'+/2 0 (lists:seq 1 6)))))"'
  end
end
