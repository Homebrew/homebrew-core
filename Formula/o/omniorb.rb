class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.3.3/omniORB-4.3.3.tar.bz2"
  sha256 "accd25e2cb70c4e33ed227b0d93e9669e38c46019637887c771398870ed45e7a"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d3e724bd8c66b8c85adde6ca4551f195147576384d7381e1fb23296a8d03c421"
    sha256 cellar: :any,                 arm64_sequoia: "3de267638de92404fea8f73f7b093ffe1e1f24431c554638e6e452c7ac2adcee"
    sha256 cellar: :any,                 arm64_sonoma:  "c1f622c04da99ede9d10731c823c7ba212a701d3e054fae614b16a36202d2849"
    sha256 cellar: :any,                 sonoma:        "d2e8bc653769aef5203ef679b70e2b8cf6c571c11f668fe2b429c542d5144166"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64c28b492eb0b7d70e9f95f1d63861bc94c2bd202d2a159be67a57b40939a1fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b00950095cce6ed4ab5f7315da5f399e71eb8befa784afcd9e0876fc80f793d9"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "python@3.14"
  depends_on "zstd"

  uses_from_macos "zlib"

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.3.3/omniORBpy-4.3.3.tar.bz2"
    sha256 "385c14e7ccd8463a68a388f4f2be3edcdd3f25a86b839575326bd2dc00078c22"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "bindings resource needs to be updated" if version != resource("bindings").version

    # Help old config scripts identify arm64 linux
    build_arg = []
    build_arg << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    ENV["PYTHON"] = python3 = which("python3.14")
    xy = Language::Python.major_minor_version python3
    inreplace "configure",
              /am_cv_python_version=`.*`/,
              "am_cv_python_version='#{xy}'"
    args = build_arg + ["--with-openssl"]
    args << "--enable-cfnetwork" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    resource("bindings").stage do
      inreplace "configure",
                /am_cv_python_version=`.*`/,
                "am_cv_python_version='#{xy}'"
      system "./configure", *build_arg, *std_configure_args
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
