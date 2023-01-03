class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "https://lfe.io/"
  url "https://github.com/lfe/lfe/archive/v2.1.0.tar.gz"
  sha256 "5554f9fec066963a6d79c8cd5f6b6eff0d1f0397425331fd88dcae9907756b66"
  license "Apache-2.0"
  head "https://github.com/lfe/lfe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0545632700f2ff959dbb62551efd7f0ea168d1ed839af42465c957f3871028e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4bd4da0c02fc08e5b326b7cdea041e9e4daef7eb767cfd9b06b2a4777344c6b"
    sha256 cellar: :any_skip_relocation, ventura:        "c4087243b64c6d8f5eecebb4c8d9a5b7661102b2f65f8ba275015d633bf6acca"
    sha256 cellar: :any_skip_relocation, monterey:       "c911ba164288b5fa4b800d33630a7f6709d473ba5aeff263f34b3713f90022c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b1a15cdc71cf54af9cf00b044694dbfe00b603d4caf3060ac1f904a95304290"
    sha256 cellar: :any_skip_relocation, catalina:       "8b6707bd8f4d0e7154d732e261001276efda9ec89f24a965ef25a8e5dfeda61a"
    sha256 cellar: :any_skip_relocation, mojave:         "774edd008cb45c6496247bcebb7370dee9555ea72563d90c5c42da23595b2b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "488bc8ec352bae436e3982e8de8b852601bcf6714ec2d34d1928d231e9abfd22"
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
