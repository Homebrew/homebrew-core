class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 16
  head "https://github.com/OpenLightingProject/ola.git", branch: "master"

  stable do
    url "https://github.com/OpenLightingProject/ola/releases/download/0.10.9/ola-0.10.9.tar.gz"
    sha256 "44073698c147fe641507398253c2e52ff8dc7eac8606cbf286c29f37939a4ebf"

    # fix liblo 0.32 header compatibility
    patch do
      url "https://github.com/OpenLightingProject/ola/commit/e083653d2d18018fe6ef42f757bc06462de87f28.patch?full_index=1"
      sha256 "1276aded269497fab2e3fc95653b5b8203308a54c40fe2dcd2215a7f0d0369de"
      type :backport
      resolves "https://github.com/OpenLightingProject/ola/pull/1954"
    end

    # Backport fix for protoc version detection
    patch do
      url "https://github.com/OpenLightingProject/ola/commit/aed518a81340a80765e258d1523b75c22a780052.patch?full_index=1"
      sha256 "7e48c0027b79e129c1f25f29fae75568a418b99c5b789ba066a4253b7176b00a"
      type :backport
    end
  end

  bottle do
    sha256 arm64_tahoe:   "188012f8a7a721a59a8876e63e451358990f32676e231963457f0a3f6fe69592"
    sha256 arm64_sequoia: "44905223123684470fede4d317c70d8de84cd222756ee87cd60bd23c2a875cc9"
    sha256 arm64_sonoma:  "bc923db1a3d91c274feb1a412148aeac7340c5a509e6fbeee54907e478ce52f2"
    sha256 sonoma:        "1e5377e888231ab33fd2cf8ad9a4501e5b87ee192efd57eb72d6798c30a3e75b"
    sha256 arm64_linux:   "62452d470f12e11c8501ab3cc1ffff0c3534099229eac5ae3cfe18c88f8b68e3"
    sha256 x86_64_linux:  "474bfbe439534e48bef1c0fd6e3067d35655f66acf49faa1f2ea7930393a2fe0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cppunit" => :build # TODO: remove once we no longer need to run tests
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "abseil"
  depends_on "liblo"
  depends_on "libmicrohttpd"
  depends_on "libusb"
  depends_on "numpy"
  depends_on "protobuf"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_sequoia do
    # Build with Xcode.app 16.4+ to work around https://github.com/OpenLightingProject/ola/issues/1982
    # https://developer.apple.com/documentation/xcode-release-notes/xcode-16_4-release-notes#Apple-Clang-Compiler
    depends_on xcode: ["16.4", :build]
  end

  on_linux do
    depends_on "util-linux"
  end

  # Apply open PR to support Protobuf 22+ API
  patch do
    url "https://github.com/OpenLightingProject/ola/commit/e22e9da89ba2267e6c2039e5c09adce514a93b36.patch?full_index=1"
    sha256 "d2ac5729b898fc9bb35f6cc46ce5e8ffc666835371991cebe46fb96c46d686a5"
    type :unofficial
    resolves "https://github.com/OpenLightingProject/ola/pull/1984"
  end
  patch do
    url "https://github.com/OpenLightingProject/ola/commit/b8c8613ebf59d0c5db0b25e9f2649c85ddf4fdf5.patch?full_index=1"
    sha256 "28cfabd2dca822dc9198c8f81ebac71b57b2984bb5d0894301665e5f7150d31c"
    type :unofficial
    resolves "https://github.com/OpenLightingProject/ola/pull/1984"
  end

  def install
    # Workaround to build with newer Protobuf due to Abseil C++ standard
    # Issue ref: https://github.com/OpenLightingProject/ola/issues/1879
    inreplace "configure.ac", "-std=gnu++11", "-std=gnu++17"
    if ENV.compiler.to_s.match?("clang")
      # Workaround until https://github.com/OpenLightingProject/ola/pull/1889
      ENV.append "CXXFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_AUTO_PTR"
      # Workaround until https://github.com/OpenLightingProject/ola/pull/1890
      ENV.append "CXXFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_BINDERS"
      ENV.append "CXXFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_UNARY_BINARY_FUNCTION"
    end

    # Skip flaky tests on macOS
    if OS.mac?
      # https://github.com/OpenLightingProject/ola/pull/1655#issuecomment-696756941
      inreplace "common/network/Makefile.mk", %r{\bcommon/network/HealthCheckedConnectionTester }, "#\\0"
      inreplace "plugins/usbpro/Makefile.mk", %r{\\\n\s*plugins/usbpro/WidgetDetectorThreadTester$}, ""
      # TODO: SelectServerTester may need confirmation on sporadic failures.
      inreplace "common/io/Makefile.mk", %r{\bcommon/io/SelectServerTester }, "#\\0"
    end

    args = %w[
      --disable-fatal-warnings
      --disable-silent-rules
      --enable-unittests
    ]

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *args, *std_configure_args
    system "make"
    # Run tests to check the workarounds applied haven't broken basic functionality.
    # TODO: Remove and revert to `--disable-unittests` when workarounds can be dropped.
    ENV.deparallelize do
      system "make", "check"
    ensure
      logs.install buildpath/"test-suite.log" if (buildpath/"test-suite.log").exist?
    end
    system "make", "install"
  end

  def caveats
    <<~EOS
      Python support has been removed due to:
        https://github.com/OpenLightingProject/ola/issues/2008
    EOS
  end

  service do
    run [opt_bin/"olad", "--no-http-quit"]
    error_log_path var/"log/olad.log"
  end

  test do
    system bin/"ola_plugin_state", "-h"
  end
end
