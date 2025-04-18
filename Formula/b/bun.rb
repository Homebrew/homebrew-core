class Bun < Formula
  desc "JavaScript runtime, bundler, test runner, and package manager"
  homepage "https://bun.sh"
  url "https://github.com/oven-sh/bun/archive/refs/tags/bun-v1.2.8.tar.gz"
  sha256 "e5439a885b7b423b72208496da7fedd0f39bfb77c5d915bb1347d444f7d744a4"
  license all_of: [
    "MIT", # Bun & most libraries
    "BSD-3-Clause",
    # add more licenses later
    # https://github.com/oven-sh/bun?tab=License-1-ov-file
  ]
  head "https://github.com/oven-sh/bun.git", branch: "main"

  depends_on "automake" => :build
  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "coreutils" => :build
  depends_on "gnu-sed" => :build
  depends_on "go" => :build
  depends_on "icu4c@77" => :build
  depends_on "libtool" => :build
  depends_on "lld" => :build
  depends_on "llvm@19" => :build
  depends_on "ninja" => :build
  depends_on "node" => :build # for bootstrap
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "zig" => :build
  depends_on "c-ares"

  uses_from_macos "libiconv"
  uses_from_macos "zlib"

  # Bun requiers `bun` binary to be built from source
  # Use pre-built binaries from npm (no need to update them in the future)
  resource "bootstrap" do
    url "https://registry.npmjs.org/bun/-/bun-1.2.0.tgz"
    sha256 "76b734ed3cd7df230aabcead08f52d9fcafa600b962c555b985a9b65883b532f"
  end

  resource "webkit" do
    # Tarballs don't work: `422: Archive creation is blocked`
    url "https://github.com/oven-sh/WebKit.git",
      tag:      "autobuild-0fdb8a30fdf815a87e5f436552580b3309399e7e",
      revision: "0fdb8a30fdf815a87e5f436552580b3309399e7e"
  end

  def install
    ENV.llvm_clang

    resource("bootstrap").stage do
      system "npm", "install", *std_npm_args(prefix: buildpath/"bootstrap-bun")
    end

    ENV.prepend_path "PATH", buildpath/"bootstrap-bun/bin"

    resource("webkit").stage do
      # Flag reference https://github.com/oven-sh/WebKit/blob/main/Dockerfile
      ENV["DEFAULT_CFLAGS"] = %w[
        -mno-omit-leaf-frame-pointer
        -fno-omit-frame-pointer
        -ffunction-sections
        -fdata-sections
        -faddrsig
        -fno-unwind-tables
        -fno-asynchronous-unwind-tables
        -DU_STATIC_IMPLEMENTATION=1
      ].join(" ")
      ENV["LTO_FLAG"] = "-flto=full -fwhole-program-vtables -fforce-emit-vtables"
      ENV["CFLAGS"] = "#{ENV["DEFAULT_CFLAGS"]} #{ENV["CFLAGS"]} #{ENV["LTO_FLAGS"]}"
      ENV["CXXFLAGS"] = %W[
        #{ENV["DEFAULT_CFLAGS"]}
        #{ENV["CXXFLAGS"]}
        #{ENV["LTO_FLAGS"]}
        -fno-c++-static-destructors
        -Wno-c++23-lambda-attributes
      ].join(" ")
      ENV["LDFLAGS"] = "-fuse-ld=lld #{ENV["LDFLAGS"]}"
      system "cmake", "-S", ".", "-B", buildpath/"bun-webkit", "-Wno-dev", "-DPORT=\"JSCOnly\"",
                      "-DENABLE_STATIC_JSC=ON", "-DENABLE_BUN_SKIP_FAILING_ASSERTIONS=ON",
                      "-DCMAKE_BUILD_TYPE=Release", "-DUSE_THIN_ARCHIVES=OFF",
                      "-DUSE_BUN_JSC_ADDITIONS=ON", "-DUSE_BUN_EVENT_LOOP=ON",
                      "-DENABLE_FTL_JIT=ON", "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
                      "-DALLOW_LINE_AND_COLUMN_NUMBER_IN_BUILTINS=ON",
                      "-DENABLE_REMOTE_INSPECTOR=ON", "-DCMAKE_EXE_LINKER_FLAGS=\"-fuse-ld=lld\"",
                      "-GNinja"
      system "cmake", "--build", buildpath/"bun-webkit"
    end

    args = %w[
      -Wno-dev
      -DUSE_STATIC_LIBATOMIC=OFF
      -DUSE_WEBKIT_ICU=ON
      -DENABLE_CCACHE=ON
      -DENABLE_LTO=ON
      -DUSE_STATIC_SQLITE=OFF
      -DWEBKIT_LOCAL=ON
    ]

    system "cmake", "-S", ".", "-B", "bun-build", *args, *std_cmake_args
    system "cmake", "--build", "bun-build"
    system "cmake", "--install", "bun-build"

    # system buildpath/"bootstrap-bun/bin/bun", "run", "build:release"
    # %w[bun bun-profile bun-profile.linker-map features.json].each { |f| bin.install f }
    # bin.install_symlink "bun" => "bunx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bun --version")

    system bin/"bun", "install", "cowsay"
    assert_match "Hello, world!", shell_output(bin/"bunx cowsay 'Hello, world!'")
  end
end
