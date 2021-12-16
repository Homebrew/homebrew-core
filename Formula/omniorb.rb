class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.2.4/omniORB-4.2.4.tar.bz2"
  sha256 "28c01cd0df76c1e81524ca369dc9e6e75f57dc70f30688c99c67926e4bdc7a6f"
  license "GPL-2.0"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3d2e59fd9deebfea609840039725a28dfec37dcc9094ec9efa5a82bca780c4bd"
    sha256 cellar: :any,                 arm64_big_sur:  "f3eb8e528df93c3a186e946e3ad0e2331147893cfaa77fa9efba6de8d698f604"
    sha256 cellar: :any,                 monterey:       "6996a065f43d78f842be1fa839c392966a3863e390ad06abdb9ad4cf64ef7dec"
    sha256 cellar: :any,                 big_sur:        "707b941b5e395565a7071d1cda7057c634ca5ee2b42ad3b3c4eff6a156888d2d"
    sha256 cellar: :any,                 catalina:       "452a5534fc3a75f84cecce1caf75316c4b3f91d3306cf5f455ee4f6e0dce3c83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12737198e9df6b4c1131c74d50b1fca299227f1818dfa28a766da1e1180c29bf"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10"

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.4/omniORBpy-4.2.4.tar.bz2"
    sha256 "dae8d867559cc934002b756bc01ad7fabbc63f19c2d52f755369989a7a1d27b6"
  end

  def install
    ENV["PYTHON"] = which("python3")
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    resource("bindings").stage do
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/omniidl", "-h"
    system "#{bin}/omniidl", "-bcxx", "-u"
    system "#{bin}/omniidl", "-bpython", "-u"
  end
end
