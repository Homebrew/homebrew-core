class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.59.tar.gz"
  sha256 "d64f03717797e7f03f9223a49777404b053a24a8001c899c1a785e51beab9a28"
  license any_of: ["GPL-1.0-or-later", "Artistic-1.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cd66111d57ed08e502ad29842d72cdf7172f75c96e3e4848352669c1ca12de20"
    sha256 cellar: :any_skip_relocation, big_sur:       "cd66111d57ed08e502ad29842d72cdf7172f75c96e3e4848352669c1ca12de20"
    sha256 cellar: :any_skip_relocation, catalina:      "0fb36eef2f007bbc44ce4972142c90d1ecb480ee8e2b9860de41d7e0df400451"
    sha256 cellar: :any_skip_relocation, mojave:        "847d98727becadd6e8a8a4e2665b55d57609e3e286e8e41af0588f654f67b627"
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
