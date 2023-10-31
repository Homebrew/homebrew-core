class BacktraceCrashpad < Formula
  desc "Backtrace version of Crashpad with file attachment support and other improvements"
  homepage "https://github.com/backtrace-labs/crashpad"
  url "https://github.com/backtrace-labs/crashpad.git",
      tag:      "v0.1.0",
      revision: "031c47b4b3349d784d330f670360bb8af0266da3"
  license "Apache-2.0"

  depends_on "cmake" => :build

  # TODO: Creating iOS variants for the client at some point
  # TODO: Add minidump_stackwalk once Backtrace supports it
  def install
    system "cmake", "-S", ".", "-B", "out", *std_cmake_args
    system "cmake", "--build", "out"
    bin.install "out/handler/handler" => "backtrace_crashpad_handler"
    lib.install "out/client/libclient.a" => "libbacktrace_crashpad_client.a"

    mkdir "#{include}/backtrace/crashpad/client"
    include.install "client/crashpad_client.h" => "backtrace/crashpad/client/crashpad_client.h"
    include.install "client/ring_buffer_annotation.h" => "backtrace/crashpad/client/ring_buffer_annotation.h"
    include.install "client/simulate_crash.h" => "backtrace/crashpad/client/simulate_crash.h"
    include.install "client/simple_address_range_bag.h" => "backtrace/crashpad/client/simple_address_range_bag.h"
    include.install "client/annotation_list.h" => "backtrace/crashpad/client/annotation_list.h"
    include.install "client/settings.h" => "backtrace/crashpad/client/settings.h"
    include.install "client/simple_string_dictionary.h" => "backtrace/crashpad/client/simple_string_dictionary.h"
    include.install "client/length_delimited_ring_buffer.h" => "backtrace/crashpad/client/length_delimited_ring_buffer.h"
    include.install "client/crashpad_info.h" => "backtrace/crashpad/client/crashpad_info.h"
    include.install "client/prune_crash_reports.h" => "backtrace/crashpad/client/prune_crash_reports.h"
    include.install "client/simulate_crash_mac.h" => "backtrace/crashpad/client/simulate_crash_mac.h"
    include.install "client/crash_report_database.h" => "backtrace/crashpad/client/crash_report_database.h"
    include.install "client/client_argv_handling.h" => "backtrace/crashpad/client/client_argv_handling.h"
    include.install "client/annotation.h" => "backtrace/crashpad/client/annotation.h"

    mkdir "#{include}/backtrace/util/file"
    include.install "util/file/file_io.h" => "backtrace/util/file/file_io.h"
    mkdir "#{include}/backtrace/util/misc"
    include.install "util/misc/capture_context.h" => "backtrace/util/misc/capture_context.h"
    mkdir "#{include}/backtrace/base"
    include.install "third_party/mini_chromium/mini_chromium/base/scoped_generic.h" => "backtrace/base/scoped_generic.h"
    mkdir "#{include}/backtrace/base/mac"
    include.install "third_party/mini_chromium/mini_chromium/base/mac/scoped_mach_port.h" => "backtrace/base/mac/scoped_mach_port.h"
    mkdir "#{include}/backtrace/base/files"
    include.install "third_party/mini_chromium/mini_chromium/base/files/file_path.h" => "backtrace/base/files/file_path.h"
    include.install "third_party/mini_chromium/mini_chromium/base/files/scoped_file.h" => "backtrace/base/files/scoped_file.h"
    mkdir "#{include}/backtrace/build"
    include.install "third_party/mini_chromium/mini_chromium/build/build_config.h" => "backtrace/build/build_config.h"
    include.install "third_party/mini_chromium/mini_chromium/build/buildflag.h" => "backtrace/build/buildflag.h"

    cmake_config = <<-EOF
add_library(backtrace::crashpad STATIC IMPORTED)
set_target_properties(backtrace::crashpad PROPERTIES
  IMPORTED_LOCATION "${CMAKE_CURRENT_LIST_DIR}/../../libbacktrace_crashpad_client.a")
target_include_directories(backtrace::crashpad 
  INTERFACE "${CMAKE_CURRENT_LIST_DIR}/../../../include/backtrace")
set(BacktraceCrashpad_FOUND TRUE)
    EOF
    cmake_version_config = <<-EOF
set(PACKAGE_VERSION "#{version}")
if(PACKAGE_FIND_VERSION VERSION_EQUAL PACKAGE_VERSION)
  set(PACKAGE_VERSION_EXACT TRUE)
endif()
if(NOT PACKAGE_FIND_VERSION VERSION_GREATER PACKAGE_VERSION)
  set(PACKAGE_VERSION_COMPATIBLE TRUE)
else(NOT PACKAGE_FIND_VERSION VERSION_GREATER PACKAGE_VERSION)
  set(PACKAGE_VERSION_UNSUITABLE TRUE)
endif()
    EOF
    mkdir "#{lib}/cmake/BacktraceCrashpad"
    File.write("#{lib}/cmake/BacktraceCrashpad/BacktraceCrashpadConfig.cmake", cmake_config)
    File.write("#{lib}/cmake/BacktraceCrashpad/BacktraceCrashpadConfigVersion.cmake", cmake_version_config)
  end

  test do
    system "#{bin}/backtrace_crashpad_handler", "--help"
  end
end