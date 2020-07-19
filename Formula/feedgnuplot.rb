class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.54.tar.gz"
  sha256 "5549e97d53a813e87938d73339df0dc858072ae5dff388541428741c9becb512"
  # licensed under either "GPL-3.0" or "Artistic-1.0"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5eba2428fbc21bf870022fd74b6fe979e41361e64f431e32ab0e29251fa4e670" => :catalina
    sha256 "ba2cbad0fe17092c8b12e09ad75bac84ed1ddd993df13e9b3d987419b96da2de" => :mojave
    sha256 "afdaaf444f096114e8eda179351a0569167c2920b746e27faabfcf6beaabe8d0" => :high_sierra
  end

  depends_on "gnuplot"

  def install
    system "perl", "Makefile.PL", "prefix=#{prefix}"
    system "make"
    system "make", "install"

    bash_completion.install "completions/bash/feedgnuplot"
    zsh_completion.install "completions/zsh/_feedgnuplot"
  end

  test do
    pipe_output("#{bin}/feedgnuplot --terminal 'dumb 80,20' --exit", "seq 5", 0)
  end
end
