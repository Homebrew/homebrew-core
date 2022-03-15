class Libetpan < Formula
  desc "Portable mail library handling several protocols"
  homepage "https://www.etpan.org/libetpan.html"
  url "https://github.com/dinhviethoa/libetpan/archive/1.9.4.tar.gz"
  sha256 "82ec8ea11d239c9967dbd1717cac09c8330a558e025b3e4dc6a7594e80d13bb1"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/dinhviethoa/libetpan.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "772546d5dd375facff503b9d1fb5618b9ebc49e6d0d8c04250edc7bcc60cd115"
    sha256 cellar: :any, arm64_big_sur:  "c72a2eeaf1b3fd67a093375fd567ff97c329d5d503abd720572eefb8d88acac3"
    sha256 cellar: :any, monterey:       "58fb1bf8eef4740ab4383ec37787e7a5885198e48d3254c1811c2ac70ff1c174"
    sha256 cellar: :any, big_sur:        "9d2ac6a48a6c14f2894155162d52ad7e8cf219ab21245b429b83378662f4a7f7"
    sha256 cellar: :any, catalina:       "2effe5528f31ea1edcdd0baf468bb1ebbfb0061cb8bf131f2636b5db6cc20550"
    sha256 cellar: :any, mojave:         "ba4948b8f0169ee43ba18b0dbea0564bfd5a2c625834f6f5a5c4b9ac1d725334"
    sha256 cellar: :any, high_sierra:    "6a2f29f42a39d9d3eee7bca1974118fdd8d44a745f61af686aa40c449157b733"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@1.1"
  end

  # Fix extra args in pkg-config file.
  # Remove with the next release.
  patch do
    url "https://github.com/dinhvh/libetpan/commit/8e904aa1c92bd0993123dd46d5a10a58f0516721.patch?full_index=1"
    sha256 "d99cb79037e147bb376effb6ae5cb1eb46201b0dda6397eba49a1beffc22d9b0"
  end

  # Fix CVE-2020-15953.
  # Remove with the next release.
  patch do
    url "https://github.com/dinhvh/libetpan/commit/1002a0121a8f5a9aee25357769807f2c519fa50b.patch?full_index=1"
    sha256 "824408a4d4b59b8e395260908b230232d4f764645b014fbe6e9660ad1137251e"
  end
  patch do
    url "https://github.com/dinhvh/libetpan/commit/298460a2adaabd2f28f417a0f106cb3b68d27df9.patch?full_index=1"
    sha256 "f5e62879eb90d83d06c4b0caada365a7ea53d4426199a650a7cc303cc0f66751"
  end

  def install
    ENV["NOCONFIGURE"] = "1"
    configure_args = std_configure_args + %w[
      --without-gnutls
      --disable-db
    ]

    # libetpan has a macOS-specific build script to create a framework.
    # For backwards compatibility reasons, let's continue to do that.
    if OS.mac?
      configure_args << "--without-openssl"
      inreplace "build-mac/update.sh", %r{\./configure (.*) >}, "./configure #{configure_args.join(" ")} >"

      cd "build-mac" do
        # Update the anciently generated autoconf result files.
        system "./update.sh", "prepare"
      end

      # Extract ABI version.
      api_current = api_revision = api_compatibility = nil
      parse_version = lambda do |line, vers_name|
        line[/^m4_define\(\[#{Regexp.escape(vers_name)}\], \[(\d+)\]\)$/, 1]&.to_i
      end
      File.foreach("configure.ac") do |line|
        api_current ||= parse_version.call(line, "api_current")
        api_revision ||= parse_version.call(line, "api_revision")
        api_compatibility ||= parse_version.call(line, "api_compatibility")
        break if api_current && api_revision && api_compatibility
      end

      current_version = "#{api_compatibility}.#{api_current - api_compatibility}.#{api_revision}"

      xcodebuild "-arch", Hardware::CPU.arch,
                 "-project", "build-mac/libetpan.xcodeproj",
                 "-scheme", "static libetpan",
                 "-configuration", "Release",
                 "SYMROOT=build/libetpan",
                 "FRAMEWORK_VERSION=#{api_compatibility}",
                 "DYLIB_COMPATIBILITY_VERSION=#{api_compatibility}",
                 "DYLIB_CURRENT_VERSION=#{current_version}",
                 "build"

      xcodebuild "-arch", Hardware::CPU.arch,
                 "-project", "build-mac/libetpan.xcodeproj",
                 "-scheme", "libetpan",
                 "-configuration", "Release",
                 "SYMROOT=build/libetpan",
                 "FRAMEWORK_VERSION=#{api_compatibility}",
                 "DYLIB_COMPATIBILITY_VERSION=#{api_compatibility}",
                 "DYLIB_CURRENT_VERSION=#{current_version}",
                 "build"

      lib.install "build-mac/build/libetpan/Release/libetpan.a"
      frameworks.install "build-mac/build/libetpan/Release/libetpan.framework"
      prefix.install "build-mac/build/libetpan/Release/include"
      cp include/"libetpan/libetpan.h", include # Compatibility header
      lib.install_symlink frameworks/"libetpan.framework/Versions/A/libetpan" => "libetpan.dylib"
      (lib/"pkgconfig").install "libetpan.pc"

      # Backwards ABI compatibility - remove this when api_compatibility is bumped past 20.
      (frameworks/"libetpan.framework/Versions").install_symlink "20" => "A"
    else
      system "./autogen.sh"
      system "./configure", *configure_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libetpan/libetpan.h>
      #include <string.h>
      #include <stdlib.h>

      int main(int argc, char ** argv)
      {
        printf("version is %d.%d", libetpan_get_version_major(), libetpan_get_version_minor());
      }
    EOS
    expected_output = "version is #{version.major_minor}"

    system ENV.cc, "test.c", "-L#{lib}", "-letpan", "-o", "test-lib"
    assert_equal expected_output, shell_output("./test-lib")

    return unless OS.mac?

    system ENV.cc, "test.c", "-F#{frameworks}", "-framework", "libetpan", "-o", "test-framework"
    assert_equal expected_output, shell_output("./test-framework")
  end
end
