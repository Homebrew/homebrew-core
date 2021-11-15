# From: Jacques Distler <distler@golem.ph.utexas.edu>
# You can always find the latest version by checking
#    https://golem.ph.utexas.edu/~distler/code/itexToMML/view/head:/itex-src/itex2MML.h
# The corresponding versioned archive is
#    https://golem.ph.utexas.edu/~distler/blog/files/itexToMML-x.x.x.tar.gz

class Itex2mml < Formula
  desc "Text filter to convert itex equations to MathML"
  homepage "https://golem.ph.utexas.edu/~distler/blog/itex2MML.html"
  url "https://golem.ph.utexas.edu/~distler/blog/files/itexToMML-1.6.1.tar.gz"
  sha256 "3ef2572aa3421cf4d12321905c9c3f6b68911c3c9283483b7a554007010be55f"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url :homepage
    regex(%r{<b>\s*Current itex2MML Version:\s*</b>\s*(\d+(?:\.\d+)+)[\s(<]}im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f08478f4813d052ae7d98339582ca05b95674d7b08a254305bf8e4e6575b3327"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a13992add208a7ab179fab850b3aba9a18a672dd803247ccde9c225103edf01"
    sha256 cellar: :any_skip_relocation, monterey:       "fa3e744eb8281aba061785ebb783c1a55d7f4a85c00787052a309411af702583"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cf7d88d4e102acb646f5e23a4bc168a50c19ce8bda26011bd25c7d8208dbb86"
    sha256 cellar: :any_skip_relocation, catalina:       "a4a3f1a4d8ff096ed6a4e1eb6ac2883d916de6504496cd8da929081484ab65c4"
    sha256 cellar: :any_skip_relocation, mojave:         "ca96d27550adc14145a18df3a31ed79dfd12d082f7e4dbccce73e8eabe4ae69e"
  end

  def install
    bin.mkpath
    cd "itex-src" do
      system "make"
      system "make", "install", "prefix=#{prefix}", "BINDIR=#{bin}"
    end
  end

  test do
    system "#{bin}/itex2MML", "--version"
  end
end
