class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.52.tar.gz"
  sha256 "ca32efe1dcfffe33533007933ab3d2c2ed62edc2bc204bfc605e0fbca6c31067"

  bottle do
    cellar :any_skip_relocation
    sha256 "377b4e52ae5383e65d77b8432c1e3c70ca58c20890daaecf5a99aafe24fb083d" => :catalina
    sha256 "112ef91d005163ee08b907f155d26648b10e86c228db0ca071852d40d26f49a5" => :mojave
    sha256 "2eab51b4c5e699e8070dba01eaf4045e869f127cbb61580132e1c16f476cf094" => :high_sierra
    sha256 "758c77d234777b923a9bb357aa80314a0ddae736b119fa0fda037f409a8a671a" => :sierra
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
