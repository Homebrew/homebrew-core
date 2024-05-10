class Libplist < Formula
  desc "Library for Apple Binary- and XML-Property Lists"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libplist/releases/download/2.5.0/libplist-2.5.0.tar.bz2"
  sha256 "72742f20a73e0a6367fbcadaf48cf903bfa45a3642a11f2224ed850d1f1e5683"
  license "LGPL-2.1-or-later"
  head "https://github.com/libimobiledevice/libplist.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "59354164cd075ee3597dfc2670b2283a439b0154730dd0f4d9ccc694cbcb54f1"
    sha256 cellar: :any,                 arm64_ventura:  "42fa24333cc5431048e01a225ded9addb37447575032d579c845eadd1b1cd4db"
    sha256 cellar: :any,                 arm64_monterey: "a8bec99b0a62f01f1078fc21207ebe68d5cb1f12925782ce0139134935ab39e4"
    sha256 cellar: :any,                 sonoma:         "10e9d29e5c3c3354a3af67dab61b1e1d98d2020e3b5e0e2780ee4b2587bc0817"
    sha256 cellar: :any,                 ventura:        "4680532f5124cd9bba37b8192ee8ecd005b05df1a15290feb18fc38ea37570bc"
    sha256 cellar: :any,                 monterey:       "666028bbd050fd8c2454c952ed04ab78043de7cd15abd0c55388c8a995098af8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "585da0b2bd5441d61b963c37a5c6f1e7bff9ea7cf88a33db857e4d95bc854975"
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
