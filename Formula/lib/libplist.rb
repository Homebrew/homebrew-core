class Libplist < Formula
  desc "Library for Apple Binary- and XML-Property Lists"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libplist/releases/download/2.4.0/libplist-2.4.0.tar.bz2"
  sha256 "3f5868ae15b117320c1ff5e71be53d29469d4696c4085f89db1975705781a7cd"
  license "LGPL-2.1-or-later"
  head "https://github.com/libimobiledevice/libplist.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "afdc2d39827539e0dbddc15df593dacab16881588a3c493c4a5f3122cc26c258"
    sha256 cellar: :any,                 arm64_ventura:  "bce85db4230154dfd54861932b06277dc55d3813c23d5afc46a87e9fa02ce997"
    sha256 cellar: :any,                 arm64_monterey: "1305668aac4e826526b34dbbd55e4b09677fa09362585fa1d1c6a9560ea5a85c"
    sha256 cellar: :any,                 sonoma:         "21ba81c3841971db75932af92ed794599621e04fd3f06545b21d64b1b7966713"
    sha256 cellar: :any,                 ventura:        "01aaa20a79c0c5546bfcc4f8cbfb20b33f736ad99c15926bd16f0887ecfea323"
    sha256 cellar: :any,                 monterey:       "bc89a045b2a3194e9031d23e270de46873bb1b83315a7fa9d03c0ea79bfca059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbd5ae373c56a2ccc93becb00ccd84c2b3320310502960994736f6b13d33299a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    ENV.deparallelize

    args = %w[
      --disable-silent-rules
      --without-cython
    ]

    system "./autogen.sh", *std_configure_args, *args if build.head?
    system "./configure", *std_configure_args, *args if build.stable?
    system "make"
    system "make", "install"
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
