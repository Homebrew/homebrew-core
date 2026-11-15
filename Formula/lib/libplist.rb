class Libplist < Formula
  desc "Library for Apple Binary- and XML-Property Lists"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libplist/releases/download/2.8.1/libplist-2.8.1.tar.bz2"
  sha256 "2a1792e5820e1657c173735fde75baeebd6dd967d2ac47be1e3891ddc64ebefa"
  license "LGPL-2.1-or-later"
  compatibility_version 2
  head "https://github.com/libimobiledevice/libplist.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2321434c852fb7f232a377636d8ab168e546f720ea3628e695a05792065bf030"
    sha256 cellar: :any, arm64_tahoe:       "6ff690a56dc4afd4aaf09d832a8ba64f7fc80ee6ecff64ad8b5673614ffaf3c8"
    sha256 cellar: :any, arm64_sequoia:     "d88d984b12e68f8470e9f72631a4711df0f85b8728c53e6c04bf2956267e84cc"
    sha256 cellar: :any, arm64_linux:       "3b79ee174bba2c391e206e86758a324b2e2fb3f9a6f366275075d5c4886ddb54"
    sha256 cellar: :any, x86_64_linux:      "553bbd2e5b172dfcf89cd5a002e99a59ef0253ef933977ecab1d7dab2aaf2a93"
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
