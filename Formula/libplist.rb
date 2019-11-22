class Libplist < Formula
  desc "Library for Apple Binary- and XML-Property Lists"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libplist/archive/2.1.0.tar.gz"
  sha256 "4b33f9af3f9208d54a3c3e1a8c149932513f451c98d1dd696fe42c06e30b7f03"

  bottle do
    cellar :any
    sha256 "9fb68734857c12ee645d64f86a425dd7f8e17049df1cbb12a539ab5a7d191b55" => :catalina
    sha256 "7c7e9cf1ba11adf0541545649d9d8e127db56c8946dc15496feed5e701440779" => :mojave
    sha256 "ce277c3c0700c1a34f47f3769dfda47c30acd8763eda9d12aaa718d456cb1b5d" => :high_sierra
  end

  head do
    url "https://git.sukimashita.com/libplist.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    ENV.deparallelize

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --without-cython
    ]

    system "./autogen.sh", *args
    system "make"
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
