class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.60.tar.gz"
  sha256 "ac84f6f316fc1b5ecc5e5afb47da1385110e3fde39e0d7429b67beee8f465722"
  license any_of: ["GPL-1.0-or-later", "Artistic-1.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4e173e7fe3dc5d0c2a875cd8607b1f06e933242aff823d74615666f4675ae31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dac5f96953b5707c4e8a78bf674d6e767a870693ca438eef83fb251cda40311"
    sha256 cellar: :any_skip_relocation, monterey:       "e4e173e7fe3dc5d0c2a875cd8607b1f06e933242aff823d74615666f4675ae31"
    sha256 cellar: :any_skip_relocation, big_sur:        "1dac5f96953b5707c4e8a78bf674d6e767a870693ca438eef83fb251cda40311"
    sha256 cellar: :any_skip_relocation, catalina:       "f2cade7e47e498c9bd2590f2f44cec6e8546b6b70670d8915175fc61c9e51695"
    sha256 cellar: :any_skip_relocation, mojave:         "488ac3106785ec103d653bec7ff854e3678583489c4f0e5320c8d984bbdda9ce"
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
