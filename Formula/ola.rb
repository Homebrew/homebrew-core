class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.8/ola-0.10.8.tar.gz"
  sha256 "102aa3114562a2a71dbf7f77d2a0fb9fc47acc35d6248a70b6e831365ca71b13"
  license "GPL-2.0"
  head "https://github.com/OpenLightingProject/ola.git"

  bottle do
    sha256 big_sur:  "01d3fbbad1714ae2f0ac902e9770798abd9d18db6412a664ddc528071c64ef4d"
    sha256 catalina: "4ac72f24e812e7c3c59fb5bef66b9e33757df3231e1c8de4c428126ad1f52dec"
    sha256 mojave:   "4b897250e2d6f1ca338ca42f420dd4edb00171e6d3c59ef776bd32e9dfe00412"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "liblo"
  depends_on "libmicrohttpd"
  depends_on "libusb"
  depends_on "numpy"
  depends_on "protobuf@3.6"
  depends_on "python@3.9"

  # remove in version 0.10.9
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/add0354bf13253a4cc89e151438a630314df0efa/ola/protobuf3.diff"
    sha256 "e06ffef1610c3b09807212d113138dae8bdc7fc8400843c25c396fa486594ebf"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].bin/"python3"
    protobuf_pth = Formula["protobuf@3.6"].opt_lib/"python#{xy}/site-packages/homebrew-protobuf.pth"
    (buildpath/".brew_home/Library/Python/#{xy}/lib/python/site-packages").install_symlink protobuf_pth

    args = %W[
      --disable-fatal-warnings
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-unittests
      --enable-python-libs
      --enable-rdm-tests
    ]

    ENV["PYTHON"] = Formula["python@3.9"].bin/"python3"
    system "autoreconf", "-fvi"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"ola_plugin_info"
  end
end
