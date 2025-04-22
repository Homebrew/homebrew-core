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
    sha256 cellar: :any,                 arm64_sequoia: "e7abf96e7284d7abf7480684e14abf446fbe20776591a9d4eb64bfcfabf3cf25"
    sha256 cellar: :any,                 arm64_sonoma:  "0062f041ee755a5499bcad12c6d304a5f84b77de5633d5fd9528b6a6035900e4"
    sha256 cellar: :any,                 arm64_ventura: "06e5fcc950f5bd8934951855e1acbca7a18777d99ca2073218ee13e888b24cac"
    sha256 cellar: :any,                 sonoma:        "93972edcb883ea5c63561cdda88284a7bd30ef24e83409a05c89fed5505c80fd"
    sha256 cellar: :any,                 ventura:       "0cb78910e40ccc4833f93ead6794755d5883be7b1f0ae27ff7af40626d880dcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04357c618eb071ed217ed53de4207e1df04180a0bb25db3c0887d7b0f0ddb9f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26ff4fff24e440de45145c7d5db68cd860036563a2dbeb1a0606fc4af2c45bc6"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "python@3.13"
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

    ENV["PYTHON"] = python3 = which("python3.13")
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
