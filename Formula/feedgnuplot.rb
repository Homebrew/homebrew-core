class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.58.tar.gz"
  sha256 "b365c5180c74146cae648b22aa56513fbe36e2360879c5e31d0a55786532a236"
  license any_of: ["GPL-1.0-or-later", "Artistic-1.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "95ac4f81cea6de374480e12c5405f91bff82b273cf3bb36e11573bc216cef391"
    sha256 cellar: :any_skip_relocation, big_sur:       "714fbc8eac16cda3975072b8143de591fc2bb8b75b06eb2a5335243c3d11e1a2"
    sha256 cellar: :any_skip_relocation, catalina:      "3a8fd0e2f1c53e42d244094d34bb0ef8bcb81dad65e53a59d847accd2b8486fb"
    sha256 cellar: :any_skip_relocation, mojave:        "e7ac7f355080a99693da97468e9dd84274b1b23d2b5574eb291d3996bc21375b"
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
