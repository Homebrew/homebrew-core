class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://github.com/OpenLightingProject/ola"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 10
  head "https://github.com/OpenLightingProject/ola.git", branch: "master"

  stable do
    url "https://github.com/OpenLightingProject/ola/releases/download/0.10.9/ola-0.10.9.tar.gz"
    sha256 "44073698c147fe641507398253c2e52ff8dc7eac8606cbf286c29f37939a4ebf"

    # fix liblo 0.32 header compatibility
    # upstream pr ref, https://github.com/OpenLightingProject/ola/pull/1954
    patch do
      url "https://github.com/OpenLightingProject/ola/commit/e083653d2d18018fe6ef42f757bc06462de87f28.patch?full_index=1"
      sha256 "1276aded269497fab2e3fc95653b5b8203308a54c40fe2dcd2215a7f0d0369de"
    end

    # Backport fix for protoc version detection
    patch do
      url "https://github.com/OpenLightingProject/ola/commit/aed518a81340a80765e258d1523b75c22a780052.patch?full_index=1"
      sha256 "7e48c0027b79e129c1f25f29fae75568a418b99c5b789ba066a4253b7176b00a"
    end
  end

  bottle do
    sha256 arm64_tahoe:   "fb34b6180f13470dce28580f9bdd350c603ede26b8bd62bb3443129c0e4d5433"
    sha256 arm64_sequoia: "c071f8995af8aff4ee3e58cf2214361bf0f6c083fda6d4ef459fb001221ca4e1"
    sha256 arm64_sonoma:  "54575f5e84d7144b90eaafee13aa99035b01722db62be371bbb6c0f45df8fc95"
    sha256 sonoma:        "40566e57d5025b96c56d24e1a7923b078472b8d60ef7b25c1b7ad3f02c66d6aa"
    sha256 arm64_linux:   "6560cf82bf62934ffa92c091bf5f6caf10a0f666757b7ff472d54a00ebea4ce6"
    sha256 x86_64_linux:  "4145a9279e35b9da53fec95e9c3d83e10470f4035a672ad1bd4eb3aa3a09fe0d"
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
  # PR ref: https://github.com/OpenLightingProject/ola/pull/1984
  patch do
    url "https://github.com/OpenLightingProject/ola/commit/e22e9da89ba2267e6c2039e5c09adce514a93b36.patch?full_index=1"
    sha256 "d2ac5729b898fc9bb35f6cc46ce5e8ffc666835371991cebe46fb96c46d686a5"
  end
  patch do
    url "https://github.com/OpenLightingProject/ola/commit/b8c8613ebf59d0c5db0b25e9f2649c85ddf4fdf5.patch?full_index=1"
    sha256 "28cfabd2dca822dc9198c8f81ebac71b57b2984bb5d0894301665e5f7150d31c"
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
