class Bun < Formula
  desc "Incredibly fast JavaScript runtime, bundler, test runner, and package manager"
  homepage "https://bun.com/"
  # Need git checkout to build. Alternatively could set GIT_SHA if we extract the commit.
  url "https://github.com/oven-sh/bun.git",
      tag:      "bun-v1.4.2",
      revision: "744846f844374847c902b5e7fd59b4342a51ef99"
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
    sha256 arm64_golden_gate: "1e749a65e17ad90e1fdad40a19481915366771a53d2548a0de1802d0e7c29c16"
    sha256 arm64_tahoe:       "0c138912583eb9fa6ed12a1cf84e6d78ee51c65bd3291fb9a758bf220469b52d"
    sha256 arm64_sequoia:     "a547f6f128597ded6bfe3f467ce46606bae741b8b9ef32d0736650a07584cf51"
    sha256 arm64_linux:       "d110a88f1f69a128605c07064d8c3d3484ce650f52304d18a4fa51c49a52b8dd"
    sha256 x86_64_linux:      "823f9cfe182892e3df144e6406a6677e3c83eb299e1468ec70352b1d5f8ac97f"
  end

  depends_on "cmake" => :build
  depends_on "llvm@21" => :build # LLVM 22 PR: https://github.com/oven-sh/bun/pull/34299
  depends_on "ninja" => :build
  depends_on "rustup" => :build # needs nightly as uses `-Z` flags and unstable `#![feature(...)]`

  uses_from_macos "llvm" => :build
  uses_from_macos "perl" => :build # for webkit
  uses_from_macos "python" => :build # for webkit
  uses_from_macos "ruby" => :build # for webkit
  uses_from_macos "unzip" => :build

  on_linux do
    depends_on "lld@21" => :build
    depends_on "icu4c@78"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  fails_with :gcc do
    cause "uses clang-specific flags"
  end

  # Bootstrap with the same Bun version as upstream CI,
  # https://github.com/oven-sh/bun/blob/bun-v#{version}/.buildkite/Dockerfile
  resource "bootstrap" do
    on_macos do
      on_arm do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.13/bun-darwin-aarch64.zip"
        version "1.3.13"
        sha256 "5467e3f65dba526b9fea98f0cce04efafc0c63e169733ec27b876a3ad32da190"
      end
      on_intel do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.13/bun-darwin-x64-baseline.zip"
        sha256 "a98ba6a480f22fda9b343626b906a4e26aa53618bf85d2bc5928ecf2ba45f0ed"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.13/bun-linux-aarch64.zip"
        version "1.3.13"
        sha256 "70bae41b3908b0a120e1e58c5c8af30e74afae3b8d11b0d3fdd8e787ddfb4b22"
      end
      on_intel do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.13/bun-linux-x64-baseline.zip"
        sha256 "9d8a24292a7068090205daac0a5a223f5f69736f5287e37bf88d3b4031edc750"
      end
    end
  end

  # Build patches for clang 23 and the macOS 27 SDK,
  # https://github.com/oven-sh/bun/issues/41141
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
    bootstrap_version = File.read(".buildkite/Dockerfile")[/OLD_BUN_VERSION="v?(\d+(?:\.\d+)+)"/i, 1]
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
diff --git a/src/jsc/bindings/JSCommonJSModule.cpp b/src/jsc/bindings/JSCommonJSModule.cpp
index 484a719..7d43b31 100644
--- a/src/jsc/bindings/JSCommonJSModule.cpp
+++ b/src/jsc/bindings/JSCommonJSModule.cpp
@@ -1568,7 +1568,7 @@ static JSC::SourceCode commonJSModuleSyntheticSourceCode(const SourceOrigin& sou
 
                 JSValue keyValue = identifierToJSValue(vm, moduleKey);
                 JSValue entry = globalObject->requireMap()->get(globalObject, keyValue);
-                RETURN_IF_EXCEPTION(scope, {});
+                RETURN_IF_EXCEPTION(scope, void());
 
                 if (entry) {
                     if (auto* moduleObject = dynamicDowncast<JSCommonJSModule>(entry)) {
@@ -1587,7 +1587,7 @@ static JSC::SourceCode commonJSModuleSyntheticSourceCode(const SourceOrigin& sou
                                 // On error, remove the module from the require map
                                 // so that it can be re-evaluated on the next require.
                                 globalObject->requireMap()->remove(globalObject, moduleObject->filename());
-                                RETURN_IF_EXCEPTION(scope, {});
+                                RETURN_IF_EXCEPTION(scope, void());
 
                                 scope.throwException(globalObject, exception);
                                 return;
@@ -1595,7 +1595,7 @@ static JSC::SourceCode commonJSModuleSyntheticSourceCode(const SourceOrigin& sou
                         }
 
                         moduleObject->toSyntheticSource(globalObject, moduleKey, exportNames, exportValues);
-                        RETURN_IF_EXCEPTION(scope, {});
+                        RETURN_IF_EXCEPTION(scope, void());
                     }
                 } else {
                     // require map was cleared of the entry
diff --git a/src/jsc/bindings/JSMockFunction.cpp b/src/jsc/bindings/JSMockFunction.cpp
index bc8f149..dfe5e15 100644
--- a/src/jsc/bindings/JSMockFunction.cpp
+++ b/src/jsc/bindings/JSMockFunction.cpp
@@ -897,7 +897,7 @@ JSC_DEFINE_HOST_FUNCTION(jsMockFunctionCall, (JSGlobalObject * lexicalGlobalObje
     auto setReturnValue = [&](JSC::JSValue value) -> void {
         if (auto* returnValuesArray = fn->returnValues.get()) {
             returnValuesArray->push(globalObject, value);
-            RETURN_IF_EXCEPTION(scope, {});
+            RETURN_IF_EXCEPTION(scope, void());
             returnValueIndex = returnValuesArray->length() - 1;
         } else {
             JSC::ObjectInitializationScope object(vm);
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
 
diff --git a/src/jsc/modules/ObjectModule.cpp b/src/jsc/modules/ObjectModule.cpp
index 5505408..4311d5b 100644
--- a/src/jsc/modules/ObjectModule.cpp
+++ b/src/jsc/modules/ObjectModule.cpp
@@ -47,7 +47,7 @@ generateObjectModuleSourceCodeForJSON(JSC::JSGlobalObject* globalObject,
         PropertyNameArrayBuilder properties(vm, PropertyNameMode::Strings,
             PrivateSymbolMode::Exclude);
         object->getPropertyNames(globalObject, properties, DontEnumPropertiesMode::Exclude);
-        RETURN_IF_EXCEPTION(scope, {});
+        RETURN_IF_EXCEPTION(scope, void());
         gcUnprotectNullTolerant(object);
 
         exportNames.append(vm.propertyNames->defaultKeyword);
@@ -61,7 +61,7 @@ generateObjectModuleSourceCodeForJSON(JSC::JSGlobalObject* globalObject,
             exportNames.append(entry);
 
             JSValue value = object->get(globalObject, entry);
-            RETURN_IF_EXCEPTION(scope, {});
+            RETURN_IF_EXCEPTION(scope, void());
             exportValues.append(value);
         }
     };
