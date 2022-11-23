class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.2.4/omniORB-4.2.4.tar.bz2"
  sha256 "28c01cd0df76c1e81524ca369dc9e6e75f57dc70f30688c99c67926e4bdc7a6f"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "a007d51613913a6441b90856096fbe7ce68f284cfb485a92289244b8bb88be25"
    sha256 cellar: :any,                 arm64_monterey: "0e05e6e0d23e598d7b23e89ddb58230369933dee00d389c56f56777e396c1687"
    sha256 cellar: :any,                 arm64_big_sur:  "1de446edfd905f9d455fc68bd4ea4e645ad5d1458f9f6011a29076f2737b0084"
    sha256 cellar: :any,                 ventura:        "ec7e5af33f76b4720bfc116c616b3c861b793c136c12b5de71d1c37adc275390"
    sha256 cellar: :any,                 monterey:       "a3deb94051db3a410b6035a3ea14b72df42e5ba9a9e37f34b7a3fcca8c484e5c"
    sha256 cellar: :any,                 big_sur:        "18881ad0bf3a710e26a80c40fe35175c6affbbeb41f237b234d1529be7bd6300"
    sha256 cellar: :any,                 catalina:       "07d60469609804fa434497a100bbbf22a24e3473ffd18931524eee975530fdff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a297fb5833f049ad78e4c613c51a6077fea5ebf153b2014790d2d2edf891f31"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10"

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.4/omniORBpy-4.2.4.tar.bz2"
    sha256 "dae8d867559cc934002b756bc01ad7fabbc63f19c2d52f755369989a7a1d27b6"
  end

  def install
    ENV["PYTHON"] = python3 = which("python3.10")
    xy = Language::Python.major_minor_version python3
    inreplace "configure",
              /am_cv_python_version=`.*`/,
              "am_cv_python_version='#{xy}'"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    resource("bindings").stage do
      inreplace "configure",
                /am_cv_python_version=`.*`/,
                "am_cv_python_version='#{xy}'"
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
