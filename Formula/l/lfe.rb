class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "https://lfe.io/"
  url "https://github.com/lfe/lfe/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "41ea68afc8bbab55c63928505ce41d91bf30751d7fc511de6d8307efdede4a4f"
  license "Apache-2.0"
  revision 1
  head "https://github.com/lfe/lfe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "142c6b31bb5bdc207e0fff1994ce38c2f81dd01368ad8648ad38b64578203dad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9ca9cc876a23e5031ed016c0ad6ed776c80824f3fed7885474117b2387f1c59"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34e32f57ba796f4824468d88c9ab77e9dfd571ca2d81d2e33a96831c02d08b27"
    sha256 cellar: :any_skip_relocation, sonoma:        "22670d643dc72207be0ee37ef5173e73e09b0b7877a650f11a92281adfac81e7"
    sha256 cellar: :any_skip_relocation, ventura:       "207a697f04f973c1dda1fc74374bb793eaee47e1e8ac20791dd5e7c349cedf86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70441d2dcde3285428c011695776fdca217e8da4c19867d4e3e98de690a30f69"
  end

  depends_on "emacs" => :build
  depends_on "erlang@26"

  def install
    system "make"
    system "make", "MANINSTDIR=#{man}", "install-man"
    system "make", "emacs"

    libexec.install "bin", "ebin"
    bin.install_symlink (libexec/"bin").children
    pkgshare.install "dev", "examples", "test"
    doc.install Pathname.glob("doc/*.txt")
    elisp.install Pathname.glob("emacs/*.elc")

    # TODO: Remove me when we depend on unversioned `erlang`.
    bin.env_script_all_files libexec, PATH: "#{Formula["erlang@26"].opt_bin}:$PATH"
  end

  test do
    system bin/"lfe", "-eval", '"(io:format \"~p\" (list (* 2 (lists:foldl #\'+/2 0 (lists:seq 1 6)))))"'
  end
end
