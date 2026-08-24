class Bun < Formula
  desc "Incredibly fast JavaScript runtime, bundler, test runner, and package manager"
  homepage "https://bun.com/"
  # Need git checkout to build. Alternatively could set GIT_SHA if we extract the commit.
  url "https://github.com/oven-sh/bun.git",
      tag:      "bun-v1.4.0",
      revision: "34cbb9a40b4bd1bd767d134a7065e66c2432a676"
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
    sha256                               arm64_tahoe:   "e3b0580902ec45450316af3115ebeb532ad7d13a0762d0c1d2ac8c2c138665f5"
    sha256                               arm64_sequoia: "bba32ee189892fac6a4a87754f97ed2151bd29ec6921f29a7e5f66d57400e155"
    sha256                               arm64_sonoma:  "4c9a4fbc278636c9a9124593f52205bd951410415ca945437b3e650f08d188e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a4c17c9fb7da44ad94825d7a3bf060f9b1a3596611236cd908a43a9da61a232"
    sha256                               arm64_linux:   "3d8fbeb5b40a8a3b885d3ef8c0f2c7de65ae353206004ffe21266715cf5fd2c7"
    sha256                               x86_64_linux:  "a0909fe4fba19d4a6b9abe2b613ea61cab901bd6a320e550284a853ec0a92782"
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

  # Work around superenv only supporting unversioned LLVM which results in enabling
  # unsupported SVE code. Based on LLVM 22 PR https://github.com/oven-sh/bun/pull/34299
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
    elsif OS.linux? && Hardware::CPU.arm64?
      inreplace "scripts/build/flags.ts", "-march=armv8-a+crc", ENV["HOMEBREW_OPTFLAGS"].to_s
    end

    fetch_webkit
    resource("bootstrap").stage("bootstrap")
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    args = ["--canary=off"]
    args << "--baseline=on" if Hardware::CPU.intel?

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
diff --git a/src/jsc/bindings/highway_json.cpp b/src/jsc/bindings/highway_json.cpp
index d3fba90f25a1..e6e1180cd2ce 100644
--- a/src/jsc/bindings/highway_json.cpp
+++ b/src/jsc/bindings/highway_json.cpp
@@ -1,6 +1,12 @@
 // SIMD structural indexer for JSON (simdjson-style "stage 1"), runtime-dispatched via Google
 // Highway. Plain JSON only: a `/` or `'` outside a string sets BUN_JSON_IDX_ODDITY and returns.
 
+// BitsFromMask needs a fixed-width vector; Highway only provides it for the
+// fixed-size SVE_256/SVE2_128 variants, not scalable SVE/SVE2. clang >= 22
+// stops marking scalable SVE as HWY_BROKEN, so disable it here explicitly.
+#undef HWY_DISABLED_TARGETS
+#define HWY_DISABLED_TARGETS (HWY_SVE | HWY_SVE2)
+
 #undef HWY_TARGET_INCLUDE
 #define HWY_TARGET_INCLUDE "highway_json.cpp"
 #include <hwy/foreach_target.h>
diff --git a/src/jsc/bindings/highway_sourcemap.cpp b/src/jsc/bindings/highway_sourcemap.cpp
index 653cdb5ee8cf..46e0a27de005 100644
--- a/src/jsc/bindings/highway_sourcemap.cpp
+++ b/src/jsc/bindings/highway_sourcemap.cpp
@@ -34,6 +34,12 @@
 //   Muła, "SIMD base64 decoding"  http://0x80.pl/notesen/2016-01-17-sse-base64-decoding.html
 //   Lemire & Boytsov, "Masked VByte"  https://arxiv.org/abs/1503.07387
 
+// BitsFromMask needs a fixed-width vector; Highway only provides it for the
+// fixed-size SVE_256/SVE2_128 variants, not scalable SVE/SVE2. clang >= 22
+// stops marking scalable SVE as HWY_BROKEN, so disable it here explicitly.
+#undef HWY_DISABLED_TARGETS
+#define HWY_DISABLED_TARGETS (HWY_SVE | HWY_SVE2)
+
 #undef HWY_TARGET_INCLUDE
 #define HWY_TARGET_INCLUDE "highway_sourcemap.cpp"
 #include <hwy/foreach_target.h> // Must come before highway.h
diff --git a/src/jsc/bindings/highway_xml.cpp b/src/jsc/bindings/highway_xml.cpp
index c7b206412e..6553e3a57e 100644
--- a/src/jsc/bindings/highway_xml.cpp
+++ b/src/jsc/bindings/highway_xml.cpp
@@ -4,6 +4,12 @@
 // U+FFFE / U+FFFF, EF BF BE|BF; units: 0xFFFE / 0xFFFF), and, between a `<` and the next `>`, of
 // every `\t`, `\n`, `"`, `'` and `=` as well.
 
+// BitsFromMask needs a fixed-width vector; Highway only provides it for the
+// fixed-size SVE_256/SVE2_128 variants, not scalable SVE/SVE2. clang >= 22
+// stops marking scalable SVE as HWY_BROKEN, so disable it here explicitly.
+#undef HWY_DISABLED_TARGETS
+#define HWY_DISABLED_TARGETS (HWY_SVE | HWY_SVE2)
+
 #undef HWY_TARGET_INCLUDE
 #define HWY_TARGET_INCLUDE "highway_xml.cpp"
 #include <hwy/foreach_target.h>
