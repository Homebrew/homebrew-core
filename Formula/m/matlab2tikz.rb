class Matlab2tikz < Formula
  desc "Convert MATLAB(R) figures into TikZ/Pgfplots figures"
  homepage "https://github.com/matlab2tikz/matlab2tikz"
  url "https://github.com/matlab2tikz/matlab2tikz/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "4e6fe80ebe4c8729650eb00679f97398c2696fd9399c17f9c5b60a1a6cf23a19"
  license "BSD-2-Clause"
  head "https://github.com/matlab2tikz/matlab2tikz.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "eb8e50b9e5382c9cf9664a559dab432dde58e071bc13d97fab006273184d3002"
  end

  depends_on "gnuplot" => :test
  depends_on "octave" => :test

  deny_network_access!

  def install
    pkgshare.install Dir["src/*"]
  end

  test do
    (testpath/"plot_test.m").write <<~MATLAB
      addpath('#{pkgshare}');
      graphics_toolkit('gnuplot');
      f = figure('visible', 'off');
      plot([1 2 3], [1 4 9]);
      matlab2tikz('test.tex', 'figurehandle', f, 'showInfo', false, ...
                  'showWarnings', false, 'checkForUpdates', false);
    MATLAB
    system formula_opt_bin("octave")/"octave-cli", "--norc", "plot_test.m"

    output = (testpath/"test.tex").read
    assert_match "\\begin{tikzpicture}", output
    assert_match "\\begin{axis}", output
    assert_match "\\addplot", output
  end
end
