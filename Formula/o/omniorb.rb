class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.3.1/omniORB-4.3.1.tar.bz2"
  sha256 "0f42bc3eb737cae680dafa85b3ae3958e9f56a37912c5fb6b875933f8fb7390d"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    sha256                               arm64_ventura:  "d3cd94cab91215f9cd5c1dae80d91f1dd67d3c4839a9d854cad2445ba69e15d8"
    sha256                               arm64_monterey: "19767e6c9a3605e7437918f0fb76c2ff979ba9083395c3a09c0e15f3ace8fdb4"
    sha256                               arm64_big_sur:  "e7cf7dc0cc5d25fc19dd23231992c866a8c98de71e2218de2971ffc48fe253fe"
    sha256                               ventura:        "0a496e43334a3d08a53e6bad65affe2b4feba979ea96d0958a3bb8d73c17db4e"
    sha256                               monterey:       "21e56446374f73df54144d9e85370373adbb3fee8e9e001a3e1ef4f5868f5d2c"
    sha256                               big_sur:        "5af9ba2b3bcb73d67474130fa20c8925394db95d09013387d705c39c651d91b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c680d35fc18fa0c8c8a9c0074896a0db6b4263fe524eefd4ba8e90ce8ffd454a"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11"

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.3.1/omniORBpy-4.3.1.tar.bz2"
    sha256 "9da34af0a0230ea0de793be73ee66dc8a87e732fec80437ea91222e272d01be2"
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
    assert_equal version, resource("bindings").version, "`bindings` resource needs updating!"

    system "#{bin}/omniidl", "-h"
    system "#{bin}/omniidl", "-bcxx", "-u"
    system "#{bin}/omniidl", "-bpython", "-u"
  end
end
