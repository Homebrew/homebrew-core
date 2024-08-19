class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.3.2/omniORB-4.3.2.tar.bz2"
  sha256 "1c745330d01904afd7a1ed0a5896b9a6e53ac1a4b864a48503b93c7eecbf1fa8"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8f30cde3ccdad77bf9eab6b1479eddf61b5fac1720562b583fa2f299ef611d08"
    sha256 cellar: :any,                 arm64_ventura:  "0c95065778587f6e4b405c7db738f2a08b5aeb7fffd8e9ad0ee106e256ecebf9"
    sha256 cellar: :any,                 arm64_monterey: "f2a6a5138718643cfd16256f7cc46040a96cab9a4daf450ed1965bceac4eebb9"
    sha256 cellar: :any,                 sonoma:         "c5f6d4a6d03750e64208d038da5448b17d5121331f96a2b8227cd16e2854ea27"
    sha256 cellar: :any,                 ventura:        "d637dcdb67360e997a38e45136c77874ec49239853dc0e038c6723851967051c"
    sha256 cellar: :any,                 monterey:       "e723599e651a6da612005e20ff8081f75cd6a259c3ee000e4eb27a81624eee34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c6ed8ba241de3cc97f66834684d84262aadd78bf9f99436c7ad7a9f09255323"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.12"

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.3.2/omniORBpy-4.3.2.tar.bz2"
    sha256 "cb5717d412a101baf430f598cac7d69231884dae4372d8e2adf3ddeebc5f7ebb"
  end

  def install
    odie "bindings resource needs to be updated" if version != resource("bindings").version

    ENV["PYTHON"] = python3 = which("python3.12")
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
    system bin/"omniidl", "-h"
    system bin/"omniidl", "-bcxx", "-u"
    system bin/"omniidl", "-bpython", "-u"
  end
end
