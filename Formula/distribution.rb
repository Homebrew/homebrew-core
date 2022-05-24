class Distribution < Formula
  desc "Create ASCII graphical histograms in the terminal"
  homepage "https://github.com/time-less-ness/distribution"
  url "https://github.com/time-less-ness/distribution/archive/1.3.tar.gz"
  sha256 "d7f2c9beeee15986d24d8068eb132c0a63c0bd9ace932e724cb38c1e6e54f95d"
  license "GPL-2.0-only"
  head "https://github.com/time-less-ness/distribution.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "46e6afa7ee3cdc08f4fde478e6235b1df80813391abe507505e1452926d5aff2"
  end

  def install
    bin.install "distribution.py" => "distribution"
    doc.install "distributionrc", "screenshot.png"
  end

  test do
    (testpath/"test").write "a\nb\na\n"
    `#{bin}/distribution <test 2>/dev/null`.include? "a|2"
  end
end
