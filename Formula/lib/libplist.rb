class Libplist < Formula
  desc "Library for Apple Binary- and XML-Property Lists"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libplist/releases/download/2.8.1/libplist-2.8.1.tar.bz2"
  sha256 "2a1792e5820e1657c173735fde75baeebd6dd967d2ac47be1e3891ddc64ebefa"
  license "LGPL-2.1-or-later"
  compatibility_version 2
  head "https://github.com/libimobiledevice/libplist.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "321b77f9c5a6a7432162874392635b3a543ca4db397c422a49471d9762af86c9"
    sha256 cellar: :any, arm64_tahoe:       "f013f0d6a0440dd4f2236afed2ffd2599f9519081a75a4d4bda8c6de33bb7e86"
    sha256 cellar: :any, arm64_sequoia:     "a19201d621e6181184e7c77a0ba59ca08f7566b42e168f746509f370ae8dbbc5"
    sha256 cellar: :any, arm64_linux:       "3d7d4814dc13e834074d6d36e1ababe85919660c8d0228117270c6cf7ab4f070"
    sha256 cellar: :any, x86_64_linux:      "9d284d178d84186d816b342c71f08d88ec9d3d1bf6036cc0faea091c6bda12d9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  deny_network_access!

  def install
    ENV.deparallelize

    args = %w[
      --disable-silent-rules
      --without-cython
    ]

    system "./autogen.sh", *args, *std_configure_args if build.head?
    system "./configure", *args, *std_configure_args if build.stable?
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.plist").write <<~XML
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
    XML
    system bin/"plistutil", "-i", "test.plist", "-o", "test_binary.plist"
    assert_path_exists testpath/"test_binary.plist", "Failed to create converted plist!"
  end
end
