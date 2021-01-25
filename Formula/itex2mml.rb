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

  livecheck do
    url "https://golem.ph.utexas.edu/~distler/code/itexToMML/view/head:/itex-src/itex2MML.h"
    regex(/#define ITEX2MML_VERSION &quot;v?(\d+(?:\.\d+)+)&quot;/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f8ce5cb49022544012a00941c46ed10a348fa01841348034b4265be1e8274f1b" => :big_sur
    sha256 "cc0d1c749ce1a12d7c90b1016b89f41e3f72c4f65a7a0dc3316600f653e99524" => :arm64_big_sur
    sha256 "61a85ab2e9536209e49b3225f98fc55c0fae709683d0f2662be459f99718bbef" => :catalina
    sha256 "df578788807a4ee50d332c710ad96c174e570362fd8c2dab01f1da328b53ba96" => :mojave
    sha256 "95e76b0109c7bc8407c32f12ef1d7f43e62c6c09363840e7b8fee35a56520312" => :high_sierra
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
