class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "https://lfe.io/"
  url "https://github.com/lfe/lfe/archive/v2.1.2.tar.gz"
  sha256 "59743c2496f72f2ad595843311f49d09ef932ffaa5bb26075c79c368a3948f80"
  license "Apache-2.0"
  head "https://github.com/lfe/lfe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a08b7c460271d852391b0e05f3120eef5d164fe49b3158e3abb2db3e54b405fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eee736be5916d8a36d610f7d6724b5f419069701d17a9614967ce9b977be0855"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14500dfdc57799e893c55fb89ba426e2c089f3018d6b31824882fbd9a2bc0403"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a34b8c05b2b42c6d4af7425b142b98aa5dee03204500d9490887bef64c8c101"
    sha256 cellar: :any_skip_relocation, sonoma:         "246902b4b7e429bacb635b801496572619e0106428fd25625a107a302d3c42a5"
    sha256 cellar: :any_skip_relocation, ventura:        "ff23c0bfe71e64e9801b67ec5937c42f6f72caf2d63a2cdd238d66a29e5ed874"
    sha256 cellar: :any_skip_relocation, monterey:       "83b88dca9519b0f56734db46a8354585be5edeab1fcd1c493d4fbdfad893a166"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fcc533ba32c6ba3a449348a681de3fe0c1afdfb6e33cef7dbfa4b67f19b2f93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2c08286e6ed51a3d9b1aa57eb4bde3fcb1456bec294f014e94953c02e7c7737"
  end

  depends_on "emacs" => :build
  depends_on "erlang@25"

  def install
    system "make"
    system "make", "MANINSTDIR=#{man}", "install-man"
    system "make", "emacs"

    libexec.install "ebin"
    pkgshare.install "dev", "examples", "test"
    doc.install Pathname.glob("doc/*.txt")
    elisp.install Pathname.glob("emacs/*.elc")

    prefix.install "bin"
    bin.env_script_all_files libexec/"bin", PATH: "#{Formula["erlang@25"].opt_bin}:${PATH}"
  end

  test do
    system bin/"lfe", "-eval", '"(io:format \"~p\" (list (* 2 (lists:foldl #\'+/2 0 (lists:seq 1 6)))))"'
  end
end
