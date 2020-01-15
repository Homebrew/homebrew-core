class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.53.tar.gz"
  sha256 "8f4a77afa64d0e110fa92d58fcda8b723aa7dcff69a29d5c3eed8b4f2bf1274e"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8c2ef5f61e56fb69ae6c52517d89854997d410966e9d926e24e6d4c08d119da" => :catalina
    sha256 "eb7c2f3bb715c28eb1430bdc73d1ab29bfc806bc44809b4b3e94449aa4e4c403" => :mojave
    sha256 "0f980cf28bb61fd225c365d898d127e445abcf7da6d383f4f5b7b7e2b04c4eaa" => :high_sierra
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
