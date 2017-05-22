class Libplist < Formula
  desc "Library for Apple Binary- and XML-Property Lists"
  homepage "http://www.libimobiledevice.org/"
  url "http://www.libimobiledevice.org/downloads/libplist-2.0.0.tar.bz2"
  sha256 "3a7e9694c2d9a85174ba1fa92417cfabaea7f6d19631e544948dc7e17e82f602"

  bottle do
    cellar :any
    sha256 "17e002302e49764d8433d7103e54b6269201f1b3ad1d8c699a280edb3e23db93" => :sierra
    sha256 "44d4da500ed4448656ce335d43ff89c8df8bfc7fd7d78515e9e111e32673e645" => :el_capitan
    sha256 "c6f8dbc8fc0431d41e73c8f7da6a1292ec7d26358208540d99f775ad9af900ca" => :yosemite
    sha256 "5bfb26555e67a5a8b144ea187e32ba4b287901e4b7358e9b617aad2ddc82f9eb" => :mavericks
    sha256 "251e34405ba2111cb2f30e0857b81072b92563ebd9efa77e240214daf106560f" => :mountain_lion
  end

  head do
    url "https://git.sukimashita.com/libplist.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "without-cython", "Skip building Cython Python bindings"

  deprecated_option "with-python" => "without-cython"

  depends_on "pkg-config" => :build
  depends_on "cython" => [:build, :recommended]

  def install
    ENV.deparallelize

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]
    args << "--without-cython" if build.without? "cython"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install", "PYTHON_LDFLAGS=-undefined dynamic_lookup"
  end

  test do
    (testpath/"test.plist").write <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>test</string>
        <key>ProgramArguments</key>
        <array>
          <string>/bin/echo</string>
        </array>
      </dict>
      </plist>
    EOS
    system bin/"plistutil", "-i", "test.plist", "-o", "test_binary.plist"
    assert_predicate testpath/"test_binary.plist", :exist?,
                     "Failed to create converted plist!"
  end
end
