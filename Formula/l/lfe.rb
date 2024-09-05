class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "https://lfe.io/"
  url "https://github.com/lfe/lfe/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "450f5eb34d19f7313e5fb5c09427b4109ce08f05f48bda9cdfd8625f5b3b0633"
  license "Apache-2.0"
  head "https://github.com/lfe/lfe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ebf3f14f994a161e791af262debd0db7b3d2e917f8945e57b6f151102a9aa92b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "872b7bab3542a805fa0bbb5f68ee6fccc4b141f6ec07115b2a65cefcade834cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dcaa4229222b7f9e85e84eb144c43ffa727bd9ac54ed78cb6f6251b12e53c70"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6f1c6ded306015efa06f98f77a84b41b1a7accff76bf67b4d2e2a5371ff4ccc"
    sha256 cellar: :any_skip_relocation, ventura:        "1977dc138db8fcc028c33a48f30a5f06eb25f5f05f1c323713ecf9271cb68448"
    sha256 cellar: :any_skip_relocation, monterey:       "736e2c542dc47042201021e5b8181412461058dea005157c72fdac7633d9fb8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68bc39a7e43dc9b7c067f67fa0ce647cdcb63cf8125ef57ce283e114bc50cf32"
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
  end

  test do
    system bin/"lfe", "-eval", '"(io:format \"~p\" (list (* 2 (lists:foldl #\'+/2 0 (lists:seq 1 6)))))"'
  end
end
