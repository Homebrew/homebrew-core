class Libplist < Formula
  desc "Library for Apple Binary- and XML-Property Lists"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libplist/archive/2.1.0.tar.gz"
  sha256 "4b33f9af3f9208d54a3c3e1a8c149932513f451c98d1dd696fe42c06e30b7f03"

  bottle do
    cellar :any
    sha256 "d5231efe6aebc645cfce3322d0cb732a6ac1f9ae9d7347b832d4e0da1ab4dc31" => :catalina
    sha256 "dc0f0c66bcc89a91e635364158077b303d259ba5ac485726072d6abaae7219b3" => :mojave
    sha256 "2139142c8404729b61bf4c97d479abbf4f5bca5a6d34c188a393ff871831afb7" => :high_sierra
    sha256 "4edadbe0762df848bca097da6f8aa147471b6bca80da86a740cede8241e84030" => :sierra
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
