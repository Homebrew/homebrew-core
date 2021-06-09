class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "https://lfe.io/"
  url "https://github.com/lfe/lfe/archive/v2.0.tar.gz"
  sha256 "373ad033bb74679766ed7414bfd6d69fbf6dd0a2337019eb117840384b9fada0"
  license "Apache-2.0"
  head "https://github.com/lfe/lfe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "774daa834a0a07aa33104c7f4bc24665dba32de41e82ca9743e300643f1a6838"
    sha256 cellar: :any_skip_relocation, big_sur:       "062c812692d43ea404a44414a764bb9ad6e3622559fa64a200246d2443fdc5c9"
    sha256 cellar: :any_skip_relocation, catalina:      "0025ffc2a3ca8ee49509ada4103a28a32142208c13e1b7841f0f33f529daac2b"
    sha256 cellar: :any_skip_relocation, mojave:        "16d8e8a9f9ab091b1184dac366bb9d83cfccfdb728f79c035362b7b86940a7af"
  end

  depends_on "erlang"

  def install
    system "make"
    system "make", "MANINSTDIR=#{man}", "install-man"
    libexec.install "bin", "ebin"
    bin.install_symlink (libexec/"bin").children
    doc.install Dir["doc/*.txt"]
    pkgshare.install "dev", "examples", "test"
  end

  test do
    system bin/"lfe", "-eval", '"(io:format \"~p\" (list (* 2 (lists:foldl #\'+/2 0 (lists:seq 1 6)))))"'
  end
end
