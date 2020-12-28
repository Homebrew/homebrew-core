class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.55.tar.gz"
  sha256 "1205afedf8ce79d8531e0d0f8f9565df365a568a0ee6a8e17738602682095303"
  license any_of: ["GPL-1.0-or-later", "Artistic-1.0"]
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "7d394a581a614dcc5130eac02310e58f994067b94a8dbd413c983157e3d37cc2" => :catalina
    sha256 "76988d6017ae6c60402ef6eb02046e4a73fbc67e64ac8f55442a661dd1689832" => :mojave
    sha256 "55c59a68946e0979048dc4ef95f8746053d4b9e8c5f0d1709f781a69708051a8" => :high_sierra
  end

  depends_on "gnuplot"

  uses_from_macos "perl"

  def install
    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}", "INSTALLSITEMAN1DIR=#{man1}"
    system "make"
    system "make", "install"

    bash_completion.install "completions/bash/feedgnuplot"
    zsh_completion.install "completions/zsh/_feedgnuplot"
  end

  test do
    pipe_output("#{bin}/feedgnuplot --terminal 'dumb 80,20' --exit", "seq 5", 0)
  end
end
