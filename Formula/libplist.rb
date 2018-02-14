class Libplist < Formula
  desc "Library for Apple Binary- and XML-Property Lists"
  homepage "https://www.libimobiledevice.org/"
  url "https://www.libimobiledevice.org/downloads/libplist-2.0.0.tar.bz2"
  sha256 "3a7e9694c2d9a85174ba1fa92417cfabaea7f6d19631e544948dc7e17e82f602"

  bottle do
    cellar :any
    sha256 "af4e7e2fe8cc73190aecccdfb918db0aed2c4e2397b8d6d86a7e5dbec1fcf767" => :high_sierra
    sha256 "da5d4dedb8a981298f8c67bf116b92dd178ed834208f6fb7a0a55987ff8cfc95" => :sierra
    sha256 "34e757ae78d7a84a8fdee4fe158409f9ebd690c477400eb836fc2ed88c1353e9" => :el_capitan
    sha256 "8279838cdf74669ce421a35ccd416f5fb6c2a33dc24515ef160086b15a88b883" => :yosemite
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
    (testpath/"test.plist").write <<~EOS
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
