class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "https://lfe.io/"
  url "https://github.com/lfe/lfe/archive/v2.1.1.tar.gz"
  sha256 "e5abacd57dc2f357dda46d8336a40046be806f5c6776f95612676c4b45f6d56b"
  license "Apache-2.0"
  head "https://github.com/lfe/lfe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50da79beba25a27df6107df9e91c9b84c9e6d08f249c04d2f1b5a56bb9543878"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23f734b4f3fae509e64dd688622f07b1ea11da38afaa6435161be3635d7d5224"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3786b6b4dd0d82bcee94553a785150beecbd199f9b10970198d210762534d0e3"
    sha256 cellar: :any_skip_relocation, ventura:        "e0c610ccb996502cd4e0359eea2d95494b5ba53337e1d58be61ed15299f39538"
    sha256 cellar: :any_skip_relocation, monterey:       "ae61c904ed305804cb8de9c7f79e45129959068177e619d69e06d5d5e23a1c33"
    sha256 cellar: :any_skip_relocation, big_sur:        "e583f87a9f632a56d0d18c9be268702aa1f9f3226edb96cc8dcc52fbdc0cbd5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9e674ffdffed2e4ef6e5a9e4d4aa9a3d8c1275a703c3b55b150f4d00dd09247"
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
