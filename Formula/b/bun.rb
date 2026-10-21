class Bun < Formula
  desc "Incredibly fast JavaScript runtime, bundler, test runner, and package manager"
  homepage "https://bun.com/"
  # Need git checkout to build. Alternatively could set GIT_SHA if we extract the commit.
  url "https://github.com/oven-sh/bun.git",
      tag:      "bun-v1.4.3",
      revision: "c6da4a4d3010e5553438c60f6bd76d981976867c"
  license all_of: [
    "MIT",
    "LGPL-2.0-or-later", # JavaScriptCore

    # Other libraries, https://github.com/oven-sh/bun/blob/main/LICENSE.md#linked-libraries
    # Ignoring ICU which is dynamically linked and reducing dual licenses to minimal set:
    "Apache-2.0",        # boringssl, simdutf, uSockets, highway, uWebsockets, Tigerbeetle
    "BSD-2-Clause",      # libarchive, libbase64, libspng
    "BSD-3-Clause",      # lol-html, libwebp, zstd
    "IJG",               # libjpeg-turbo
    "LGPL-2.1-or-later", # tinycc
    "Zlib",              # zlib-ng
    "Apache-2.0" => { with: "LLVM-exception" }, # __cxa_thread_atexit
  ]

  livecheck do
    url :stable
    regex(/^bun[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "1884cc7d66623250146673e57e2a4ee2a9bbde6db8a7c0d1af80014243912c77"
    sha256 arm64_tahoe:       "0a8b872558cf06a5acecd6ec7e31bd08af9390212cf70e5f61b8bb8712148696"
    sha256 arm64_sequoia:     "167bc297590aaeedfe095c18a568b8c41b7b5fdc53fa636e488afc1f63312dd8"
    sha256 arm64_linux:       "87929e9a7bdf5e31e5ed84cad46ad74dbceb568e3891896ea2562fcfa56dbfea"
    sha256 x86_64_linux:      "3b04b8447e5bf3944c08528b4ca8c18c4029cec9a3acbef6a72449a7bd260ae8"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "perl" => :build # for webkit
  uses_from_macos "python" => :build # for webkit
  uses_from_macos "ruby" => :build # for webkit
  uses_from_macos "unzip" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "icu4c@78"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  fails_with :gcc do
    cause "uses clang-specific flags"
  end

  # Bootstrap with the same Bun version as upstream CI,
  # https://github.com/oven-sh/bun/blob/bun-v#{version}/scripts/build/ci-images/spec.ts
  resource "bootstrap" do
    on_macos do
      on_arm do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.4.2/bun-darwin-aarch64.zip"
        version "1.4.2"
        sha256 "90987a3a16d7db556d886ac3d551e7b6d3edf0a1cf43acaed622e8676be1d12f"
      end
      on_intel do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.4.2/bun-darwin-x64-baseline.zip"
        sha256 "bad5bbd6cf14d0980d115f5954c9ff904df619d5e994d2da1ffccd3f316300b0"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.4.2/bun-linux-aarch64.zip"
        version "1.4.2"
        sha256 "54328bbc2d9c8e0c9f892c544d66c57a83b84139e34909e5ee81758f1ac8fda7"
      end
      on_intel do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.4.2/bun-linux-x64-baseline.zip"
        sha256 "c678040f14fe0440eb839d37cbd0ce4c051a32da72806ac97de6a6aab6bf728f"
      end
    end
  end

  # Build patches for clang 23 and the macOS 27 SDK,
  # https://github.com/oven-sh/bun/issues/41141
  # Also replaces nightly-only `core::mem::type_info::of` to build with stable Rust
  patch :DATA

  # Performing a manual shallow git clone since a full clone of WebKit repo is ~18GB in size
  # and brew's unpack strategy will duplicate a resource requiring over 36GB of disk space.
  # This exceeds limit of GitHub-hosted runners. A shallow git clone is instead ~7GB.
  def fetch_webkit
    webkit_version = File.read("scripts/build/deps/webkit.ts")[/WEBKIT_VERSION = "(\h+)"/i, 1]
    odie "Unable to find WebKit version!" if webkit_version.blank?

    clone_args = %W[
      --branch=autobuild-#{webkit_version}
      --config=advice.detachedHead=false
      --config=core.fsmonitor=false
      --depth=1
    ]
    system "git", "clone", *clone_args, "https://github.com/oven-sh/WebKit.git", "vendor/WebKit"

    # Homebrew's swiftc shim causes misconfiguration as Apple expects a valid installation
    on_linux do
      inreplace "vendor/WebKit/Source/cmake/WebKitFeatures.cmake",
                "find_program(_WEBKIT_PROBE_SWIFTC NAMES swiftc)", ""
    end
  end

  # Based on https://github.com/oven-sh/bun/blob/main/CONTRIBUTING.md#building-webkit-locally--debug-mode-of-jsc
  def install
    bootstrap_version = File.read("scripts/build/ci-images/spec.ts")[/^\s*bun: \{ version: "(\d+(?:\.\d+)+)" \}/, 1]
    odie "Update bootstrap to #{bootstrap_version}" if resource("bootstrap").version != bootstrap_version

    # Upstream only allows building for specific microarchitectures they support
    # so we need to patch build scripts to be compatible with our CPU targets
    # as part of compilation occurs outside of our superenv.
    if Hardware::CPU.intel?
      inreplace "scripts/build/flags.ts", "-march=nehalem", ENV["HOMEBREW_OPTFLAGS"].to_s
      # 1.4.1 raised libspng's x64 SIMD floor from SSE2 to SSE4.1 to match the
      # nehalem target replaced above. Our baseline has no SSE4.1, and the
      # defilter paths are `always_inline`, so drop back to the 1.4.0 level.
      inreplace "scripts/build/deps/libspng.ts", "{ SPNG_SSE: 4 }", "{ SPNG_SSE: 1 }"
    elsif OS.linux? && Hardware::CPU.arm64?
      inreplace "scripts/build/flags.ts", "-march=armv8-a+crc", ENV["HOMEBREW_OPTFLAGS"].to_s
    end

    ENV["RUSTC_BOOTSTRAP"] = "1" # workaround to build with stable rust
    # Nested dep builds run `cmake --build` without `--parallel`, four at a time
    # (the `dep` ninja pool), so each one spawns its own core-count worth of
    # compilers on top of the outer build and Homebrew's job limit is ignored.
    ENV["CMAKE_BUILD_PARALLEL_LEVEL"] = ENV.make_jobs.to_s

    fetch_webkit
    resource("bootstrap").stage("bootstrap")
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    args = ["--canary=off"]
    args << "--baseline=on" if Hardware::CPU.intel?
    # Unless it detects CI, bun takes the deployment target from the SDK's major
    # version, so Xcode 27 on macOS 26 would build everything `minos 27.0`.
    args << "--osx-deployment-target=#{MacOS.version}" if OS.mac?

    system "bun", "run", "build:release:local", *args
    bin.install "build/release-local/bun"
    bin.install_symlink bin/"bun" => "bunx"

    bash_completion.install "completions/bun.bash" => "bun"
    fish_completion.install "completions/bun.fish"
    zsh_completion.install "completions/bun.zsh" => "_bun"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bun --version")
    refute_match "canary", shell_output("#{bin}/bun --revision")

    system bin/"bun", "init", "--yes"
    assert_equal "Hello via Bun!", shell_output("#{bin}/bun run index.ts").chomp

    system bin/"bun", "build", "--compile", "--outfile=test", "index.ts"
    assert_equal "Hello via Bun!", shell_output("./test").chomp

    assert_match "< hello bun >", shell_output("#{bin}/bunx cowsay hello bun")

    # Test SQLite API which loads system library on macOS
    (testpath/"db.ts").write <<~TYPESCRIPT
      import { Database } from "bun:sqlite";
      const db = new Database(":memory:");
      db.run("create table students (name text, age integer)");
      db.run("insert into students (name, age) values ('Bob', 14)");
      db.run("insert into students (name, age) values ('Sue', 12)");
      db.run("insert into students (name, age) values ('Tim', 13)");
      const query = db.query("select name from students order by age asc");
      console.log(query.values().flat());
    TYPESCRIPT
    assert_equal '[ "Sue", "Tim", "Bob" ]', shell_output("#{bin}/bun run db.ts").chomp
  end
end

__END__
diff --git a/src/collections/lib.rs b/src/collections/lib.rs
index 57539df..46e4209 100644
--- a/src/collections/lib.rs
+++ b/src/collections/lib.rs
@@ -6,9 +6,10 @@
     unsized_const_params,
     const_cmp,
     const_trait_impl,
-    allocator_api
+    allocator_api,
+    core_intrinsics
 )]
-#![allow(incomplete_features)]
+#![allow(incomplete_features, internal_features)]
 #![warn(unused_must_use)]
 
 pub mod hive_array;
diff --git a/src/collections/multi_array_list.rs b/src/collections/multi_array_list.rs
index fda15fa..3af1d82 100644
--- a/src/collections/multi_array_list.rs
+++ b/src/collections/multi_array_list.rs
@@ -47,7 +47,11 @@
 
 use core::alloc::Layout;
 use core::marker::PhantomData;
-use core::mem::type_info;
+mod type_info {
+    pub(super) const fn of<T: ?Sized>() -> core::any::TypeId {
+        const { core::intrinsics::type_id::<T>() }
+    }
+}
 use core::mem::{ManuallyDrop, MaybeUninit};
 use core::ptr::{self, NonNull};
 use std::alloc::{Allocator, Global};
diff --git a/src/jsc/bindings/JSNodePerformanceHooksHistogram.cpp b/src/jsc/bindings/JSNodePerformanceHooksHistogram.cpp
index 0f72fd6..7ab0c64 100644
--- a/src/jsc/bindings/JSNodePerformanceHooksHistogram.cpp
+++ b/src/jsc/bindings/JSNodePerformanceHooksHistogram.cpp
@@ -172,13 +172,13 @@ int64_t JSNodePerformanceHooksHistogram::getMax() const
 
 double JSNodePerformanceHooksHistogram::getMean() const
 {
-    if (!m_histogramData.histogram) return NAN;
+    if (!m_histogramData.histogram) return std::numeric_limits<double>::quiet_NaN();
     return hdr_mean(m_histogramData.histogram);
 }
 
 double JSNodePerformanceHooksHistogram::getStddev() const
 {
-    if (!m_histogramData.histogram) return NAN;
+    if (!m_histogramData.histogram) return std::numeric_limits<double>::quiet_NaN();
     return hdr_stddev(m_histogramData.histogram);
 }
 
diff --git a/src/jsc/bindings/c-bindings.cpp b/src/jsc/bindings/c-bindings.cpp
index 481ccdd..1ff80f1 100644
--- a/src/jsc/bindings/c-bindings.cpp
+++ b/src/jsc/bindings/c-bindings.cpp
@@ -1143,6 +1143,11 @@ extern "C" const char* BUN_DEFAULT_PATH_FOR_SPAWN = "/usr/bin:/bin";
 #include <os/signpost.h>
 #include "generated_perf_trace_events.h"
 
+// The SDK applies an Apple-clang-only attribute here, unguarded.
+// https://github.com/oven-sh/bun/issues/41141
+#pragma clang diagnostic push
+#pragma clang diagnostic ignored "-Wunknown-attributes"
+
 // The event names have to be compile-time constants.
 // So we trick the compiler into thinking they are by using a macro.
 extern "C" void Bun__signpost_emit(os_log_t log, os_signpost_type_t type, os_signpost_id_t spid, int trace_event_id)
@@ -1160,6 +1165,8 @@ extern "C" void Bun__signpost_emit(os_log_t log, os_signpost_type_t type, os_sig
     }
 }
 
+#pragma clang diagnostic pop
+
 #undef EMIT_SIGNPOST
 #undef FOR_EACH_TRACE_EVENT
