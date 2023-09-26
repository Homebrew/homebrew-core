class Crashpad < Formula
  desc "Crash reporting system for client applications"
  homepage "https://chromium.googlesource.com/crashpad/crashpad"
  url "https://chromium.googlesource.com/crashpad/crashpad/+archive/8da335ffad361191fa467de56a30715223f04014.tar.gz"
  version "8da335ffad361191fa467de56a30715223f04014"
  sha256 "5f1cc88caacd9efaf7683d2afa8ba3e6cf7f17ff4e8a5f3f2a575a34bfff8f48"
  license "Apache-2.0"
  depends_on "ninja" => :build
  depends_on "python@3.9" => :build
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "d95084e85101b865a8f1d213b6fbe3c11384e82f"
  end

  def install
    resource("depot-tools").stage(buildpath/"depot-tools")
    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.append_path "PATH", "#{buildpath}/depot-tools"

    system "gclient", "config", "--name", "crashpad", "https://chromium.googlesource.com/crashpad/crashpad.git@#{version}"
    system "gclient", "sync", "--no-history"

    chdir "crashpad" do
      system "gn", "gen", "out/Default"
      system "ninja", "-C", "out/Default"
      
      static_libs = Dir.glob("out/default/obj/client/*.a")
      puts "Static libraries found: #{static_libs.inspect}"

      (prefix/"lib").install Dir["out/Default/obj/handler/*.a"]
      (prefix/"lib").install Dir["out/Default/obj/snapshot/*.a"]
      # (prefix/"lib").install Dir["out/Default/obj/test/*.a"]
      (prefix/"lib").install Dir["out/Default/obj/util/*.a"]
      (prefix/"lib").install Dir["out/Default/obj/third_party/mini_chromium/mini_chromium/base/*.a"]
      # (prefix/"lib").install Dir["out/Default/obj/third_party/googletest/*.a"]
      (prefix/"lib").install Dir["out/Default/obj/minidump/*.a"]
      (prefix/"lib").install Dir["out/Default/obj/client/*.a"]
      
      (prefix/"include/crashpad/handler").install Dir["handler/*.h"]
      (prefix/"include/crashpad/handler/win").install Dir["handler/win/*.h"]
      (prefix/"include/crashpadhandler/mac").install Dir["handler/mac/*.h"]
      (prefix/"include/crashpad/handler/linux").install Dir["handler/linux/*.h"]
      (prefix/"include/crashpad/snapshot").install Dir["snapshot/*.h"]
      (prefix/"include/crashpad/snapshot/posix").install Dir["snapshot/posix/*.h"]
      # (prefix/"include/crashpad/snapshot/test").install Dir["snapshot/test/*.h"]
      (prefix/"include/crashpad/snapshot/win").install Dir["snapshot/win/*.h"]
      (prefix/"include/crashpad/snapshot/fuchsia").install Dir["snapshot/fuchsia/*.h"]
      (prefix/"include/crashpad/snapshot/ios").install Dir["snapshot/ios/*.h"]
      (prefix/"include/crashpad/snapshot/mac").install Dir["snapshot/mac/*.h"]
      (prefix/"include/crashpad/snapshot/x86").install Dir["snapshot/x86/*.h"]
      (prefix/"include/crashpad/snapshot/linux").install Dir["snapshot/linux/*.h"]
      (prefix/"include/crashpad/snapshot/minidump").install Dir["snapshot/minidump/*.h"]
      (prefix/"include/crashpad/snapshot/crashpad_types").install Dir["snapshot/crashpad_types/*.h"]
      (prefix/"include/crashpad/snapshot/sanitized").install Dir["snapshot/sanitized/*.h"]
      (prefix/"include/crashpad/snapshot/elf").install Dir["snapshot/elf/*.h"]
      (prefix/"include/crashpad/tools").install Dir["tools/*.h"]
      (prefix/"include/crashpad/compat/non_mac/mach").install Dir["compat/non_mac/mach/*.h"]
      (prefix/"include/crashpad/compat/non_mac/mach-o").install Dir["compat/non_mac/mach-o/*.h"]
      (prefix/"include/crashpad/compat/win").install Dir["compat/win/*.h"]
      (prefix/"include/crashpad/compat/win/sys").install Dir["compat/win/sys/*.h"]
      (prefix/"include/crashpad/compat/mac").install Dir["compat/mac/*.h"]
      (prefix/"include/crashpad/compat/mac/kern").install Dir["compat/mac/kern/*.h"]
      (prefix/"include/crashpad/compat/mac/sys").install Dir["compat/mac/sys/*.h"]
      (prefix/"include/crashpad/compat/mac/mach/i386").install Dir["compat/mac/mach/i386/*.h"]
      (prefix/"include/crashpad/compat/mac/mach").install Dir["compat/mac/mach/*.h"]
      (prefix/"include/crashpad/compat/mac/mach-o").install Dir["compat/mac/mach-o/*.h"]
      (prefix/"include/crashpad/compat/linux").install Dir["compat/linux/*.h"]
      (prefix/"include/crashpad/compat/linux/sys").install Dir["compat/linux/sys/*.h"]
      # (prefix/"include/crashpad/compat/android").install Dir["compat/andoid/*.h"]
      # (prefix/"include/crashpad/compat/android/sys").install Dir["compat/andoid/sys/*.h"]
      (prefix/"include/crashpad/compat/non_win").install Dir["compat/non_win/*.h"]
      # (prefix/"include/crashpad/compat/android/linux").install Dir["compat/andoid/linux/*.h"]
      (prefix/"include/crashpad/util/misc").install Dir["util/misc/*.h"]
      (prefix/"include/crashpad/util/posix").install Dir["util/posix/*.h"]
      (prefix/"include/crashpad/util/net").install Dir["util/net/*.h"]
      (prefix/"include/crashpad/util/synchronization").install Dir["util/synchronization/*.h"]
      (prefix/"include/crashpad/util/file").install Dir["util/file/*.h"]
      (prefix/"include/crashpad/util/win").install Dir["util/win/*.h"]
      (prefix/"include/crashpad/util/stream").install Dir["util/stream/*.h"]
      (prefix/"include/crashpad/util/fuchsia").install Dir["util/fuchsia/*.h"]
      (prefix/"include/crashpad/util/ios").install Dir["util/ios/*.h"]
      (prefix/"include/crashpad/util/mac").install Dir["util/mac/*.h"]
      (prefix/"include/crashpad/util/numeric").install Dir["util/numeric/*.h"]
      (prefix/"include/crashpad/util/linux").install Dir["util/linux/*.h"]
      (prefix/"include/crashpad/util/stdlib").install Dir["util/stdlib/*.h"]
      (prefix/"include/crashpad/util/mach").install Dir["util/mach/*.h"]
      (prefix/"include/crashpad/util/string").install Dir["util/string/*.h"]
      (prefix/"include/crashpad/util/thread").install Dir["util/thread/*.h"]
      (prefix/"include/crashpad/util/process").install Dir["util/process/*.h"]
      (prefix/"include/crashpad/out/Default/gen/util/mach").install Dir["out/Default/gen/util/mach/*.h"]
      (prefix/"include/crashpad/out/Default/gen/build/").install Dir["out/Default/gen/build/*.h"]
      (prefix/"include/crashpad").install Dir["*.h"]
      # (prefix/"include/crashpad/third_party/libfuzzer/src").install Dir["third_party/libfuzzer/src/*.h"]
      (prefix/"include/crashpad/third_party/getopt").install Dir["third_party/getopt/*.h"]
      (prefix/"include/crashpad/third_party/zlib").install Dir["third_party/zlib/*.h"]
      (prefix/"include/crashpad/third_party/zlib/zlib").install Dir["third_party/zlib/zlib/*.h"]
      (prefix/"include/crashpad/third_party/zlib/zlib/google").install Dir["third_party/zlib/zlib/google/*.h"]
      (prefix/"include/crashpad/third_party/zlib/zlib/contrib/minizip").install Dir["third_party/zlib/zlib/contrib/minizip/*.h"]
      # (prefix/"include/crashpad/third_party/mini_chromium/mini_chromium/testing").install Dir["third_party/mini_chromium/mini_chromium/testing/*.h"]
      (prefix/"include/crashpad/third_party/mini_chromium/mini_chromium/build").install Dir["third_party/mini_chromium/mini_chromium/build/*.h"]
      (prefix/"include/crashpad/third_party/mini_chromium/mini_chromium/base/apple").install Dir["third_party/mini_chromium/mini_chromium/base/apple/*.h"]
      (prefix/"include/crashpad/third_party/mini_chromium/mini_chromium/base/metrics").install Dir["third_party/mini_chromium/mini_chromium/base/metrics/*.h"]
      (prefix/"include/crashpad/third_party/mini_chromium/mini_chromium/base/posix").install Dir["third_party/mini_chromium/mini_chromium/base/posix/*.h"]
      (prefix/"include/crashpad/third_party/mini_chromium/mini_chromium/base/strings").install Dir["third_party/mini_chromium/mini_chromium/base/strings/*.h"]
      (prefix/"include/crashpad/third_party/mini_chromium/mini_chromium/base/types").install Dir["third_party/mini_chromium/mini_chromium/base/types/*.h"]
      (prefix/"include/crashpad/third_party/mini_chromium/mini_chromium/base/memory").install Dir["third_party/mini_chromium/mini_chromium/base/memory/*.h"]
      (prefix/"include/crashpad/third_party/mini_chromium/mini_chromium/base/synchronization").install Dir["third_party/mini_chromium/mini_chromium/base/synchronization/*.h"]
      (prefix/"include/crashpad/third_party/mini_chromium/mini_chromium/base/fuchsia").install Dir["third_party/mini_chromium/mini_chromium/base/fuchsia/*.h"]
      (prefix/"include/crashpad/third_party/mini_chromium/mini_chromium/base/numerics").install Dir["third_party/mini_chromium/mini_chromium/base/numerics/*.h"]
      (prefix/"include/crashpad/third_party/mini_chromium/mini_chromium/base/mac").install Dir["third_party/mini_chromium/mini_chromium/base/mac/*.h"]
      (prefix/"include/crashpad/third_party/mini_chromium/mini_chromium/base/third_party/icu").install Dir["third_party/mini_chromium/mini_chromium/base/third_party/icu/*.h"]
      (prefix/"include/crashpad/third_party/mini_chromium/mini_chromium/base/files").install Dir["third_party/mini_chromium/mini_chromium/base/files/*.h"]
      (prefix/"include/crashpad/third_party/mini_chromium/mini_chromium/base/threading").install Dir["third_party/mini_chromium/mini_chromium/base/threading/*.h"]
      (prefix/"include/crashpad/third_party/mini_chromium/mini_chromium/base/process").install Dir["third_party/mini_chromium/mini_chromium/base/process/*.h"]
      (prefix/"include/crashpad/third_party/mini_chromium/mini_chromium/base").install Dir["third_party/mini_chromium/mini_chromium/base/*.h"]
      (prefix/"include/crashpad/third_party/mini_chromium/mini_chromium/base/debug").install Dir["third_party/mini_chromium/mini_chromium/base/debug/*.h"]
      # (prefix/"include/crashpad/third_party/googletest/googletest/googletest/test").install Dir["third_party/googletest/googletest/googletest/test/*.h"]
      # (prefix/"include/crashpad/third_party/googletest/googletest/googletest/include/gtest/internal").install Dir["third_party/googletest/googletest/googletest/include/gtest/internal/*.h"]
      # (prefix/"include/crashpad/third_party/googletest/googletest/googletest/include/gtest/internal/custom").install Dir["third_party/googletest/googletest/googletest/include/gtest/internal/custom/*.h"]
      # (prefix/"include/crashpad/third_party/googletest/googletest/googletest/include/gtest").install Dir["third_party/googletest/googletest/googletest/include/gtest/*.h"]
      # (prefix/"include/crashpad/third_party/googletest/googletest/googletest/samples").install Dir["third_party/googletest/googletest/googletest/samples/*.h"]
      # (prefix/"include/crashpad/third_party/googletest/googletest/googletest/src").install Dir["third_party/googletest/googletest/googletest/src/*.h"]
      # (prefix/"include/crashpad/third_party/googletest/googletest/googlemock/test").install Dir["third_party/googletest/googletest/googlemock/test/*.h"]
      # (prefix/"include/crashpad/third_party/googletest/googletest/googlemock/include/gmock/internal").install Dir["third_party/googletest/googletest/googlemock/include/gmock/internal/*.h"]
      # (prefix/"include/crashpad/third_party/googletest/googletest/googlemock/include/gmock/internal/custom").install Dir["third_party/googletest/googletest/googlemock/include/gmock/internal/custom/*.h"]
      # (prefix/"include/crashpad/third_party/googletest/googletest/googlemock/include/gmock").install Dir["third_party/googletest/googletest/googlemock/include/gmock/*.h"]
      (prefix/"include/crashpad/third_party/cpp-httplib/cpp-httplib").install Dir["third_party/cpp-httplib/cpp-httplib/*.h"]
      (prefix/"include/crashpad/third_party/lss").install Dir["third_party/lss/*.h"]
      # (prefix/"include/crashpad/third_party/lss/lss/tests").install Dir["third_party/lss/lss/tests/*.h"]
      (prefix/"include/crashpad/third_party/lss/lss").install Dir["third_party/lss/lss/*.h"]
      (prefix/"include/crashpad/third_party/xnu/EXTERNAL_HEADERS/mach-o").install Dir["third_party/xnu/EXTERNAL_HEADERS/mach-o/*.h"]
      (prefix/"include/crashpad/doc/support").install Dir["doc/support/*.h"]
      (prefix/"include/crashpad/minidump").install Dir["minidump/*.h"]
      # (prefix/"include/crashpad/minidump/test").install Dir["minidump/test/*.h"]
      (prefix/"include/crashpad/client").install Dir["client/*.h"]
      (prefix/"include/crashpad/client/ios_handler").install Dir["client/ios_handler/*.h"]

      (prefix/"bin").install Dir["out/Default/ring_buffer_annotation_load_test"]
      (prefix/"bin").install Dir["out/Default/crashpad_handler"]
      (prefix/"bin").install Dir["out/Default/crashpad_handler_test_extended_handler"]
      (prefix/"bin").install Dir["out/Default/crashpad_snapshot_test_no_op"]
      (prefix/"bin").install Dir["out/Default/crashpad_test_test_multiprocess_exec_test_child"]
      (prefix/"bin").install Dir["out/Default/dump_minidump_annotations"]
      (prefix/"bin").install Dir["out/Default/crashpad_database_util"]
      (prefix/"bin").install Dir["out/Default/crashpad_http_upload"]
      (prefix/"bin").install Dir["out/Default/base94_encoder"]
      (prefix/"bin").install Dir["out/Default/generate_dump"]
      (prefix/"bin").install Dir["out/Default/run_with_crashpad"]
      (prefix/"bin").install Dir["out/Default/catch_exception_tool"]
      (prefix/"bin").install Dir["out/Default/exception_port_tool"]
      (prefix/"bin").install Dir["out/Default/on_demand_service_tool"]
      (prefix/"bin").install Dir["out/Default/http_transport_test_server"]

      # handler/BUILD.gn:  crashpad_executable("crashpad_handler_trampoline") 
      # handler/BUILD.gn:  crashpad_executable("crashpad_handler_com")
      # handler/BUILD.gn:  crashpad_executable("crash_other_program")
      # handler/BUILD.gn:  crashpad_executable("crashy_program")
      # handler/BUILD.gn:  crashpad_executable("crashy_signal")
      # handler/BUILD.gn:  crashpad_executable("fake_handler_that_crashes_at_startup")
      # handler/BUILD.gn:  crashpad_executable("hanging_program")
      # handler/BUILD.gn:  crashpad_executable("self_destroying_program")
      # handler/BUILD.gn:  crashpad_executable("heap_corrupting_program")
      # handler/BUILD.gn:    crashpad_executable("crashy_z7_loader")
      # handler/BUILD.gn:  crashpad_executable("fastfail_program")
      # snapshot/BUILD.gn:  crashpad_executable("crashpad_snapshot_test_crashing_child")
      # snapshot/BUILD.gn:  crashpad_executable("crashpad_snapshot_test_dump_without_crashing")
      # snapshot/BUILD.gn:  crashpad_executable("crashpad_snapshot_test_extra_memory_ranges")
      # snapshot/BUILD.gn:  crashpad_executable("crashpad_snapshot_test_image_reader")
      # util/BUILD.gn:  crashpad_executable("crashpad_util_test_process_info_test_child")
      # util/BUILD.gn:  crashpad_executable("crashpad_util_test_safe_terminate_process_test_child")

      lib.install_symlink (prefix/"lib").children
      # include.install_symlink (prefix/"include/crashpad").children
      bin.install_symlink (prefix/"bin").children
    end
  end
  test do
    # Verify that Crashpad tools are installed
    system "#{bin}/minidump_stackwalk", "--version"
  end
end