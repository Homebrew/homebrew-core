# From: Jacques Distler <distler@golem.ph.utexas.edu>
# You can always find the latest version by checking
#    https://golem.ph.utexas.edu/~distler/code/itexToMML/view/head:/itex-src/itex2MML.h
# The corresponding versioned archive is
#    https://golem.ph.utexas.edu/~distler/blog/files/itexToMML-x.x.x.tar.gz

class Itex2mml < Formula
  desc "Text filter to convert itex equations to MathML"
  homepage "https://golem.ph.utexas.edu/~distler/blog/itex2MML.html"
  url "https://golem.ph.utexas.edu/~distler/blog/files/itexToMML-1.6.0.tar.gz"
  sha256 "5b85b7d77da36af6aba1a56588ce9209b2309d1e99a1b3e6ae8a6d602c30efbb"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b81ff0943c636da1c59d2dd2d3e00911e2534e350e015360dc374b2d1fbc2f3" => :catalina
    sha256 "94806b5914e031608d459ce11c9d0377588b30f66442c1d86e74c915d763dd51" => :mojave
    sha256 "571c1069b19131d921c7b07ea4a4a055d33e9d5ff861787d5abd794773a2a87d" => :high_sierra
    sha256 "08b3ab528d7fc4d010cfa95bae7f6c1bb087e4304e0eeedfbdfc44b20cca11fd" => :sierra
    sha256 "f7a80cfc09e71828c01e5526912e4b49136d31e7134b95928dfb39dc6d6b5259" => :el_capitan
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
