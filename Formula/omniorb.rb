class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.3.0/omniORB-4.3.0.tar.bz2"
  sha256 "976045a2341f4e9a85068b21f4bd928993292933eeecefea372db09e0219eadd"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8a1bd5fc62fcb50642d89dc77b1b5f378438527aae9c69b608e204e823a5cf20"
    sha256 cellar: :any,                 arm64_monterey: "9c7e3d2dcd7ac8c591160666e183f8c0aa9a91ca491e83675ce8dc2805d810e7"
    sha256 cellar: :any,                 arm64_big_sur:  "7e9c59958a5e4559a445980c1e650d099fd23ffec2ec4e454042e4fbc7a8ebc6"
    sha256 cellar: :any,                 ventura:        "d6970fc1b68bc9183e8fbee25f9dbe6072a0b4c28dfb389406cae1d069337083"
    sha256 cellar: :any,                 monterey:       "8a011894c47b31f2df0aa65e8a1ca7ce0a42797c698c19b427f01dd99f0f4c87"
    sha256 cellar: :any,                 big_sur:        "21cfb7a3ba41db2904735ad3b5e9c5fb51130c69c6c8f8aab4bbb814a7d40cb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b74116ad828a1bebc30cf8ad8c45c538003c10a9207d89ed3e161aa8eb4e3919"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11"

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.3.0/omniORBpy-4.3.0.tar.bz2"
    sha256 "fffcfdfc34fd6e2fcc45d803d7d5db5bd4d188a747ff9f82b3684a753e001b4d"
  end

  def install
    ENV["PYTHON"] = python3 = which("python3.11")
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
      ENV.deparallelize # omnipy.cc:392:44: error: use of undeclared identifier 'OMNIORBPY_DIST_DATE'
      system "make", "install"
    end
  end

  test do
    system "#{bin}/omniidl", "-h"
    system "#{bin}/omniidl", "-bcxx", "-u"
    system "#{bin}/omniidl", "-bpython", "-u"
  end
end
