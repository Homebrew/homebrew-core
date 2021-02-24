class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.9.tar.gz"
  sha256 "66b62f479ad141322351d62aff76e4882719d08f8f29b35f97d30f355391a54e"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e4d2379bb03d78feef5ef1e04763f6d94de3acfee0a87f0289c566d3ed6a3676"
    sha256 cellar: :any_skip_relocation, big_sur:       "d02b38b0410d5983dfe5d142974d8f9713a1ac345b20225146f37ce3ec0680d8"
    sha256 cellar: :any_skip_relocation, catalina:      "e232b5172991d5110227e92a738c44ef39186f54106c65b09291bfbee0cc836d"
    sha256 cellar: :any_skip_relocation, mojave:        "f9018b9a8fb972c116aa4a619f6be51762ab71c5cfc9c50d150f74735f90643c"
  end

  depends_on "sphinx-doc" => :build
  depends_on "pyqt"
  depends_on "python@3.9"

  uses_from_macos "rsync"

  def install
    ENV.delete("PYTHONPATH")
    system "make", "PYTHON=#{Formula["python@3.9"].opt_bin}/python3", "prefix=#{prefix}", "install"
    system "make", "install-doc", "PYTHON=#{Formula["python@3.9"].opt_bin}/python3}", "prefix=#{prefix}",
           "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
  end

  test do
    system "#{bin}/git-cola", "--version"
  end
end
