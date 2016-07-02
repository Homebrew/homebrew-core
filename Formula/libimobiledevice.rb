class Libimobiledevice < Formula
  desc "Library to communicate with iOS devices natively"
  homepage "http://www.libimobiledevice.org/"
  url "http://www.libimobiledevice.org/downloads/libimobiledevice-1.2.0.tar.bz2"
  sha256 "786b0de0875053bf61b5531a86ae8119e320edab724fc62fe2150cc931f11037"

  bottle do
    cellar :any
    sha256 "db353988bbd70c57409338bba501a618e1d92e920e409ef587a870618878c18c" => :el_capitan
    sha256 "b13e2074ea7c8bb541b9604c6f2cdcdf8b55ee53ddbb541c1b9905ec09bd0c1c" => :yosemite
    sha256 "1ef2fe290630098b2c868d10625af7bd66a244c21b0290ae611072ab3fdedb01" => :mavericks
    sha256 "9b1c6444d223a9eb99dcade6ee8382a062701293b5e6ddaa11e23405e4d92977" => :mountain_lion
  end

  head do
    url "https://git.libimobiledevice.org/libimobiledevice.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "libxml2"
  end

  option "with-python", "Enable Cython Python bindings"
  option "with-python3", "Enable Cython Python3 bindings"

  libplist_depends = []
  libplist_depends << "with-python" if build.with? "python"
  libplist_depends << "with-python3" if build.with? "python3"

  depends_on "pkg-config" => :build
  depends_on "libtasn1"
  depends_on "usbmuxd"
  depends_on "openssl"
  depends_on "libplist" => libplist_depends
  depends_on :python => :optional
  depends_on :python3 => :optional

  resource "cython" do
    url "https://github.com/cython/cython/archive/0.24.tar.gz"
    sha256 "b60b91f1ec88921a423d5f0a5e2a7c232cdff12d9130088014bf89d542ce137b"
  end

  if build.with?("python") && build.with?("python3")
    raise "Either python or python3 bindings can be installed at the same time."
  end

  patch do
    # ensure python3 compatibility
    url "https://github.com/libimobiledevice/libimobiledevice/pull/335.patch"
    sha256 "ceb6076131ea204f411bf2d6eb584b83c300f2caf8def1c34a781920039e0063"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    if build.with? "python3"
      version = Language::Python.major_minor_version "python3"
      resource("cython").stage do
        ENV.prepend_create_path "PYTHONPATH", buildpath/"lib/python#{version}/site-packages"
        system "python3", *Language::Python.setup_install_args(buildpath)
      end
      ENV.prepend_path "PATH", buildpath/"bin"

      args << "PYTHON=python3"
      args << "PYTHON_LDFLAGS=-undefined dynamic_lookup"
    elsif build.with? "python"
      resource("cython").stage do
        ENV.prepend_create_path "PYTHONPATH", buildpath/"lib/python2.7/site-packages"
        system "python", *Language::Python.setup_install_args(buildpath)
      end
      ENV.prepend_path "PATH", buildpath/"bin"
    else
      args << "--without-cython"
    end

    system "./autogen.sh" if build.head?
    inreplace "cython/Makefile.in", "-no-undefined", ""
    system "./configure", *args
    system "make", "install", "PYTHON_LDFLAGS=-undefined dynamic_lookup"
  end

  test do
    system "#{bin}/idevice_id"
  end

  test do
    system "#{bin}/idevicedate", "--help"
  end
end
