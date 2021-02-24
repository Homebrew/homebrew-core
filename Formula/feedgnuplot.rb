class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.57.tar.gz"
  sha256 "4d4b9f0e1817962933f47b46c977c4ccde00a492b90b9e2a065674811752c569"
  license any_of: ["GPL-1.0-or-later", "Artistic-1.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b9d32714e04ce5b5b6d8e1db91e18286ccce0bd2f88e1d54505d444cfa62bf99"
    sha256 cellar: :any_skip_relocation, big_sur:       "1d4447c7553c01def874cfa7d08ad3ca7d99314402762097e5498ef99cd1ab04"
    sha256 cellar: :any_skip_relocation, catalina:      "fedc8176ca4322779b294c99d65ef7578cea1bbf268e602362d32300b0631079"
    sha256 cellar: :any_skip_relocation, mojave:        "9a15973f4140546ace9591b889f604f7c5aee5e74493d1c4d00f53d620ce9e72"
  end

  depends_on "gnuplot"

  def install
    system "perl", "Makefile.PL", "prefix=#{prefix}"
    system "make"
    system "make", "install"
    prefix.install Dir[prefix/"local/*"]

    bash_completion.install "completions/bash/feedgnuplot"
    zsh_completion.install "completions/zsh/_feedgnuplot"
  end

  test do
    pipe_output("#{bin}/feedgnuplot --terminal 'dumb 80,20' --exit", "seq 5", 0)
  end
end
