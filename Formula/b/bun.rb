class Bun < Formula
  desc "Incredibly fast JavaScript runtime, bundler, test runner, and package manager"
  homepage "https://bun.com/"
  url "https://github.com/oven-sh/bun/archive/refs/tags/bun-v1.4.5.tar.gz"
  sha256 "118dc25c12ec4ef3d95b597866a477079e170a071c79ccebca90954e05b0215e"
  license all_of: [
    "MIT",
    "LGPL-2.0-or-later", # JavaScriptCore

    # Other libraries, https://github.com/oven-sh/bun/blob/main/LICENSE.md#linked-libraries
    # Ignoring ICU which is dynamically linked and reducing dual licenses to minimal set:
    "Apache-2.0",        # boringssl, simdutf, uSockets, highway, uWebsockets, Tigerbeetle
    "BSD-2-Clause",      # libarchive, libbase64, libspng
    "BSD-3-Clause",      # lol-html, libwebp, zstd
    "IJG",               # libjpeg-turbo
    "ISC",               # glob-parent, eslint-plugin-promise, @handlebars/parser
    "LGPL-2.1-or-later", # tinycc
    "Zlib",              # zlib-ng
    "Apache-2.0" => { with: "LLVM-exception" }, # __cxa_thread_atexit
  ]
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^bun[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "b54ecf130921ac0e6a1de956855740d2ba0e5cf2a17a33a3c30e86be338b2420"
    sha256 arm64_golden_gate: "dedb3c7e91fa5da117dea4c01f9709b123aa4b1d1fa8a739ae96557d4e9e2019"
    sha256 arm64_tahoe:       "204e417d93e48dda51889d5fea60a7228aed6d265dd5f66f02e3c5ecc37d5999"
    sha256 arm64_sequoia:     "2b3fef43cfc0dac7514947fd189c5571dd5c575094dab5b9f99ea3c8112b5fbb"
    sha256 arm64_linux:       "0ec120ba299078d3aac02927846d679a6ac6c9e0bfb0406d3223720ff5586354"
    sha256 x86_64_linux:      "95cf103159110588bdf6b7a010243389a753d07ccf741f697b8ac85fdae3b5ef"
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
    depends_on "icu4c@79"
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
    checksums = {
      "linux-x64"      => "bf8ccbfb2b0b80159e0f9a6d15c55317add8077534dbc6130a3edb52fccb395c",
      "linux-aarch64"  => "baa6bb36f51d6e58561e02bbea825038a9df454f673d6d776e8bbf86f8c7850e",
      "darwin-x64"     => "50a3491f73abc2fe81673171a85762d3bc2cc1680ccecadd983de99adf77977e",
      "darwin-aarch64" => "c240d7f0ccb90c263a849fcdb09b7ee62630d921348ed6aafda86b9d577bc510",
    }

    version "1.4.4"

    on_macos do
      on_arm do
        url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-aarch64.zip"
        sha256 checksums["darwin-aarch64"]
      end
      on_intel do
        url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64.zip"
        sha256 checksums["darwin-x64"]
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-aarch64.zip"
        sha256 checksums["linux-aarch64"]
      end
      on_intel do
        url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64.zip"
        sha256 checksums["linux-x64"]
      end
    end
  end

  # Allow building with Rust 1.100.0 until release with https://github.com/oven-sh/bun/pull/49051
  patch do
    file "Patches/bun/rust-1.100.0.diff"
    type :unofficial # mostly a backport but some differences for stable Rust
  end

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
    bootstrap_version = File.read("scripts/build/ci-images/spec.ts")[/^\s*bun: \{\n\s*version: "(\d+(?:\.\d+)+)"/m, 1]
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

    ENV["GIT_SHA"] = Utils::Git.get_tar_commit_id(cached_download)
    ENV["RUSTC_BOOTSTRAP"] = "1" # workaround to build with stable rust
    # Nested dep builds run `cmake --build` without `--parallel`, four at a time
    # (the `dep` ninja pool), so each one spawns its own core-count worth of
    # compilers on top of the outer build and Homebrew's job limit is ignored.
    ENV["CMAKE_BUILD_PARALLEL_LEVEL"] = ENV.make_jobs.to_s

    fetch_webkit
    resource("bootstrap").stage("bootstrap")
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    args = ["--canary=off"]
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

    bun_revision = shell_output("#{bin}/bun --revision")
    refute_match "canary", bun_revision
    refute_match "unknown", bun_revision

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
