class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.52.tar.gz"
  sha256 "ca32efe1dcfffe33533007933ab3d2c2ed62edc2bc204bfc605e0fbca6c31067"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6f00b17519378944d02640d187db840c316b9cf730882504a51f036c737dbaf5" => :mojave
    sha256 "898fe29c81b8ceaecbdb94db803e0ed9c715100eee54a259ad84a6b0ce5a66af" => :high_sierra
    sha256 "c72aa3fa82a3a6a685fe3e1d55d16a7e22f4fa343422b019f08c954b0f709599" => :sierra
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
