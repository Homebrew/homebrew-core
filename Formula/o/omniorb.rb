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
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "7dad83e3408b60a83ddd709184b764e22cecbed96ae9ace42bf3c39ab80779fc"
    sha256 cellar: :any,                 arm64_sonoma:  "1142ccfc4a9440ed428bac77af4ebcd35486fcacec87c947522a1a2b0068fdfa"
    sha256 cellar: :any,                 arm64_ventura: "bbc4041068f7bfe1b51e2a283b4aaf7a69a5a22a3b3c7fce853368895bb7873e"
    sha256 cellar: :any,                 sonoma:        "5663bcf43193332bc6a3d75d44821ee05d1e386f638b6897f825c2afb6c7367f"
    sha256 cellar: :any,                 ventura:       "6572ba9aea26b870f54e487a8b9dfbf8248e59df2b25416acdeb96ce60f24588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c9e139a01ab68b128a4cb5ca256ffb4c7f022542cc300e225483675b2a3aed3"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "python@3.13"
  uses_from_macos "zlib"

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.3.2/omniORBpy-4.3.2.tar.bz2"
    sha256 "cb5717d412a101baf430f598cac7d69231884dae4372d8e2adf3ddeebc5f7ebb"
  end

  def install
    odie "bindings resource needs to be updated" if version != resource("bindings").version

    ENV["PYTHON"] = python3 = which("python3.13")
    xy = Language::Python.major_minor_version python3
    inreplace "configure",
              /am_cv_python_version=`.*`/,
              "am_cv_python_version='#{xy}'"
    args = ["--with-openssl"]
    args << "--enable-cfnetwork" if OS.mac?
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    resource("bindings").stage do
      inreplace "configure",
                /am_cv_python_version=`.*`/,
                "am_cv_python_version='#{xy}'"
      system "./configure", *std_configure_args
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
