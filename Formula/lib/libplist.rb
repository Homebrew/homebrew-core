class Libplist < Formula
  desc "Library for Apple Binary- and XML-Property Lists"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libplist/releases/download/2.7.0/libplist-2.7.0.tar.bz2"
  sha256 "7ac42301e896b1ebe3c654634780c82baa7cb70df8554e683ff89f7c2643eb8b"
  license "LGPL-2.1-or-later"
  head "https://github.com/libimobiledevice/libplist.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2c8a4a7e8bf9c45f9434bbc3487148f467b9a6e03f62096d90e82a2d62762b77"
    sha256 cellar: :any,                 arm64_sequoia: "bc9f54c183ce7595f0467c2d8cd8a717e41fc5faf6401e188a210f16b3e04bff"
    sha256 cellar: :any,                 arm64_sonoma:  "06036e6de87c0a8bfc917d72f2af3f63ea6eb557391035782ca8bddb5506c342"
    sha256 cellar: :any,                 arm64_ventura: "ff220e5eab9f73928cb74198a245052a195c68d42e3f02ebcf623470c461fe4d"
    sha256 cellar: :any,                 sonoma:        "1ee2a67e37b9aa465a9ce313101ab32cd3bc4959c6613c6cf844d01ce078adc3"
    sha256 cellar: :any,                 ventura:       "93e6458295e03f9d407de1668d4b74b6862837c85d27543742046e6f5f9a5d9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c794ad878825bf09dd2f6bd40440fc0dadf9094c359b448ff13e9c2b9f0e1f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f36cb92e347dee363b01764ed57da3051621da3986188e483c7dcde0425f08a1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

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
    assert_path_exists testpath/"test_binary.plist", "Failed to create converted plist!"
  end
end
