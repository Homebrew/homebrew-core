class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 15
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
    sha256 arm64_tahoe:   "77004bce4944590b9f90d29f2f851d7ed3a4c3492d30f42d1275ee01d9d01d40"
    sha256 arm64_sequoia: "b0b9240be2dc9026715b32a57d1c00cb6547cdd8aa845997f59e97b14c294e2b"
    sha256 arm64_sonoma:  "5bf57d358419f4f4347e02e2f9906690e5610ca230b1ad3726541f113b0fd0b6"
    sha256 sonoma:        "b4376d718cf88790cb4ead8a2f1eaa080ee237f4ecb31bab96964f062c2ee02b"
    sha256 arm64_linux:   "ae114687fb582078a925411b8193dd70bdacde43f7c3035721c1f5d77906eed8"
    sha256 x86_64_linux:  "577cf7b728f0aa5ff252f6e0646cae08dae1f01e1a65db85c6d49b4facf6079d"
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
