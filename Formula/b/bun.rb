class Bun < Formula
  desc "Incredibly fast JavaScript runtime, bundler, test runner, and package manager"
  homepage "https://bun.com"
  url "https://github.com/oven-sh/bun.git",
      tag:      "bun-v1.3.9",
      revision: "cf6cdbbbadd50604bc17f21ed5d0612c920a5d9a"
  license all_of: [
    "MIT",          # Bun itself and most dependencies
    "Apache-2.0",   # boringssl, simdutf, uSockets, and others
    "BSD-3-Clause", # boringssl, lol-html
    "BSD-2-Clause", # libbase64
    "Zlib",         # zlib
  ]
  head "https://github.com/oven-sh/bun.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.12" => :build
  depends_on "rust" => :build

  on_macos do
    on_sonoma :or_older do
      depends_on "llvm" => :build
    end
  end

  on_linux do
    depends_on "lld" => :build
    depends_on "llvm" => :build
  end

  # Use the official release binary only as a bootstrap compiler for
  # building Bun from source.
  resource "bun-bootstrap" do
    on_macos do
      on_arm do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.9/bun-darwin-aarch64.zip", using: :nounzip
        sha256 "cde6a4edf19cf64909158fa5a464a12026fd7f0d79a4a950c10cf0af04266d85"
      end
      on_intel do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.9/bun-darwin-x64.zip", using: :nounzip
        sha256 "588f4a48740b9a0c366a00f878810ab3ab5e6734d29b7c3cbdd9484b74a007de"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.9/bun-linux-aarch64.zip"
        sha256 "a2c2862bcc1fd1c0b3a8dcdc8c7efb5e2acd871eb20ed2f17617884ede81c844"
      end
      on_intel do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.9/bun-linux-x64.zip"
        sha256 "4680e80e44e32aa718560ceae85d22ecfbf2efb8f3641782e35e4b7efd65a1aa"
      end
    end
  end

  def install
    if OS.linux? && ENV["CI"]
      # Linux ARM CI runners are prone to OOM with default parallel build settings.
      if Hardware::CPU.arm?
        ENV.deparallelize
        ENV["CMAKE_BUILD_PARALLEL_LEVEL"] = "1"
      else
        # Keep some parallelism on Linux x86_64 to avoid CI timeouts.
        ENV["CMAKE_BUILD_PARALLEL_LEVEL"] = "2"
      end
    end

    if OS.linux?
      # Bun's CMake config passes Clang-specific flags that fail with GCC.
      ENV["CC"] = Formula["llvm"].opt_bin/"clang"
      ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
      # Highway can emit evex512 ignored-attribute warnings that become errors.
      ENV.append "CXXFLAGS", "-Wno-ignored-attributes"
    end
    if OS.linux? && Hardware::CPU.intel?
      # Keep Linux x86_64 builds off unstable AVX3/AVX512 Highway targets.
      ENV.append "CXXFLAGS",
                 "-DHWY_DISABLED_TARGETS=HWY_AVX3+HWY_AVX3_DL+HWY_AVX3_ZEN4+HWY_AVX3_SPR+HWY_AVX10_2"
    end
    if OS.linux?
      # GCC 12/libstdc++ marks temporary-buffer helpers deprecated and Bun treats
      # warnings as errors in TextCodecCJK.
      ENV.append "CXXFLAGS", "-Wno-error=deprecated-declarations"
    end
    if OS.mac? && MacOS.version <= :sonoma
      # AppleClang on macOS 14 treats unnamed parameters in C stubs as C2x
      # extension warnings, and Bun builds with -Werror.
      ENV.append "CFLAGS", "-Wno-error=c2x-extensions"
    end

    # Some Bun CMake sub-builds fail to auto-detect archive tools under Homebrew
    # superenv and emit CMAKE_AR-NOTFOUND.
    ENV["AR"] = "ar"
    ENV["RANLIB"] = "ranlib"

    resource("bun-bootstrap").stage buildpath/"bootstrap"
    if (bootstrap_zip = Dir[buildpath/"bootstrap"/"*.zip"].first)
      system "unzip", "-q", bootstrap_zip, "-d", buildpath/"bootstrap"
    end
    bootstrap_bin = Dir[buildpath/"bootstrap"/"**/bun"].first
    raise "bootstrap bun binary not found" if bootstrap_bin.nil?

    (buildpath/"bootstrap-bin").mkpath
    cp bootstrap_bin, buildpath/"bootstrap-bin/bun"
    chmod 0755, buildpath/"bootstrap-bin/bun"
    ENV.prepend_path "PATH", buildpath/"bootstrap-bin"

    # Avoid warning-option portability breakages under newer AppleClang/GCC.
    ENV.append "CFLAGS", "-Wno-unknown-warning-option"
    ENV.append "CXXFLAGS", "-Wno-undefined-var-template -Wno-unknown-warning-option"

    # Bun 1.3.9 defines this dSYM post-build hook with no explicit SOURCES.
    # register_command rejects that, so wire the built bun binary as a source.
    inreplace "cmake/targets/BuildBun.cmake",
              "      TARGET\n        ${bun}\n      TARGET_PHASE\n",
              "      TARGET\n        ${bun}\n      SOURCES\n        ${BUILD_PATH}/${bun}\n      TARGET_PHASE\n"
    # Apple strip lacks Bun's GNU-style options in this block.
    inreplace "cmake/targets/BuildBun.cmake",
              "    set(CMAKE_STRIP_FLAGS --remove-section=__TEXT,__eh_frame " \
              "--remove-section=__TEXT,__unwind_info " \
              "--remove-section=__TEXT,__gcc_except_tab)\n",
              "    set(CMAKE_STRIP_FLAGS)\n"
    inreplace "cmake/targets/BuildBun.cmake",
              "          --strip-all\n          --strip-debug\n          --discard-all\n",
              ""
    # Older Apple clang rejects this zlib workaround flag as unknown.
    # Keep it only when the current compiler supports it.
    inreplace "cmake/targets/BuildZlib.cmake",
              <<~EOS,
                if(APPLE)
                  set(ZLIB_CMAKE_C_FLAGS "-fno-define-target-os-macros")
                  set(ZLIB_CMAKE_CXX_FLAGS "-fno-define-target-os-macros")
                endif()
              EOS
              <<~EOS
                if(APPLE)
                  include(CheckCCompilerFlag)
                  include(CheckCXXCompilerFlag)
                  check_c_compiler_flag("-fno-define-target-os-macros" ZLIB_HAS_NO_DEFINE_TARGET_OS_MACROS_C)
                  check_cxx_compiler_flag("-fno-define-target-os-macros" ZLIB_HAS_NO_DEFINE_TARGET_OS_MACROS_CXX)
                  if(ZLIB_HAS_NO_DEFINE_TARGET_OS_MACROS_C)
                    set(ZLIB_CMAKE_C_FLAGS "-fno-define-target-os-macros")
                  endif()
                  if(ZLIB_HAS_NO_DEFINE_TARGET_OS_MACROS_CXX)
                    set(ZLIB_CMAKE_CXX_FLAGS "-fno-define-target-os-macros")
                  endif()
                endif()
              EOS
    # WebKit autobuild artifacts can contain this typo in JSArrayInlines.h.
    inreplace "cmake/tools/SetupWebKit.cmake",
              "file(RENAME ${CACHE_PATH}/bun-webkit ${WEBKIT_PATH})\n",
              <<~EOS
                file(RENAME ${CACHE_PATH}/bun-webkit ${WEBKIT_PATH})
                if(EXISTS ${WEBKIT_INCLUDE_PATH}/JavaScriptCore/JSArrayInlines.h)
                  file(READ ${WEBKIT_INCLUDE_PATH}/JavaScriptCore/JSArrayInlines.h JSARRAYINLINES_CONTENT)
                  string(REPLACE "DirectArgumeLts" "DirectArguments" JSARRAYINLINES_CONTENT "${JSARRAYINLINES_CONTENT}")
                  file(WRITE ${WEBKIT_INCLUDE_PATH}/JavaScriptCore/JSArrayInlines.h "${JSARRAYINLINES_CONTENT}")
                endif()
              EOS
    if OS.mac? && Hardware::CPU.arm? && MacOS.version <= :sequoia
      # macOS 14/15 Apple Silicon SDK headers declare this symbol without noexcept.
      inreplace "src/bun.js/bindings/workaround-missing-symbols.cpp",
                "void std::__libcpp_verbose_abort(char const* format, ...) noexcept",
                "void std::__libcpp_verbose_abort(char const* format, ...)"
    end
    if OS.mac?
      # macOS 14's compiler does not support deducing-this syntax in this block.
      inreplace "src/bun.js/bindings/napi.h",
                <<~EOS,
                  struct EitherCleanupHook : std::variant<SyncCleanupHook, AsyncCleanupHook> {
                      template<typename Self>
                      auto& get(this Self& self)
                      {
                          using Hook = MatchConst<Self, CleanupHook>::type;

                          if (auto* sync = std::get_if<SyncCleanupHook>(&self)) {
                              return static_cast<Hook&>(*sync);
                          }

                          return static_cast<Hook&>(std::get<AsyncCleanupHook>(self));
                      }
                EOS
                <<~EOS
                  struct EitherCleanupHook : std::variant<SyncCleanupHook, AsyncCleanupHook> {
                      using std::variant<SyncCleanupHook, AsyncCleanupHook>::variant;

                      CleanupHook& get()
                      {
                          if (auto* sync = std::get_if<SyncCleanupHook>(this)) {
                              return static_cast<CleanupHook&>(*sync);
                          }

                          return static_cast<CleanupHook&>(std::get<AsyncCleanupHook>(*this));
                      }

                      const CleanupHook& get() const
                      {
                          if (auto* sync = std::get_if<SyncCleanupHook>(this)) {
                              return static_cast<const CleanupHook&>(*sync);
                          }

                          return static_cast<const CleanupHook&>(std::get<AsyncCleanupHook>(*this));
                      }
                EOS
    end
    if OS.mac? && MacOS.version <= :sonoma
      # AppleClang 15 rejects parenthesized aggregate init for this C-style type.
      inreplace "src/bun.js/bindings/BunProcess.cpp",
                "new Bun::NapiModuleMeta(globalObject->m_pendingNapiModuleDlopenHandle);",
                "new Bun::NapiModuleMeta{globalObject->m_pendingNapiModuleDlopenHandle};"
      inreplace "src/bun.js/bindings/napi.cpp",
                "new Bun::NapiModuleMeta(globalObject->m_pendingNapiModuleDlopenHandle);",
                "new Bun::NapiModuleMeta{globalObject->m_pendingNapiModuleDlopenHandle};"
      # AppleClang 15 cannot deduce this aggregate's template argument from
      # designated initializers.
      inreplace "src/bun.js/bindings/node/crypto/KeyObject.cpp",
                "auto buf = ncrypto::Buffer {",
                "auto buf = ncrypto::Buffer<const unsigned char> {"
      # AppleClang 15 doesn't apply CWG2518; keep this assertion dependent.
      inreplace "src/vm/SigintWatcher.h",
                "static_assert(false, \"Invalid held type\");",
                "static_assert(sizeof(T) == 0, \"Invalid held type\");"
      # AppleClang 15 rejects several consteval string builders in this helper.
      # These names are for diagnostics only, so keep simpler literals on Sonoma.
      inreplace "src/bun.js/bindings/BunIDLHumanReadable.h" do |s|
        s.gsub!(/
          static\ constexpr\ auto\ humanReadableName\ =\ Bun::concatCStrings\(
          \s*Detail::nestedHumanReadableName<IDL>\(\),
          \s*Detail::separatorForHumanReadableBinaryDisjunction<IDL>\(\),
          \s*"(?:null|undefined)"\);
          \s*
        /mx,
                "static constexpr auto humanReadableName = std::to_array(\"value\");\n")
        s.gsub!(/
          static\ constexpr\ auto\ humanReadableName\s*=\s*Bun::concatCStrings\(
          "array\ of\ ",\s*Detail::nestedHumanReadableName<IDL>\(\)\);\s*
        /mx,
                "static constexpr auto humanReadableName = std::to_array(\"array\");\n")
        s.gsub!(/static constexpr auto humanReadableName\s*=\s*Bun::joinCStringsAsList\(Detail::nestedHumanReadableName<IDL>\(\)\.\.\.\);\s*/m,
                "static constexpr auto humanReadableName = std::to_array(\"value\");\n")
      end
    end

    # Bun's SetupLLVM helper can append CMAKE_AR/CMAKE_RANLIB with NOTFOUND
    # values, which later surfaces as "CMAKE_AR-NOTFOUND: command not found".
    inreplace "cmake/tools/SetupLLVM.cmake",
              "  find_llvm_command(CMAKE_AR llvm-ar)\n",
              <<~EOS
                find_llvm_command(CMAKE_AR llvm-ar)
                if(CMAKE_AR MATCHES "NOTFOUND")
                  find_command(VARIABLE CMAKE_AR COMMAND ar REQUIRED ON)
                  list(APPEND CMAKE_ARGS -DCMAKE_AR=${CMAKE_AR})
                endif()
              EOS
    inreplace "cmake/tools/SetupLLVM.cmake",
              "  find_llvm_command(CMAKE_RANLIB llvm-ranlib)\n",
              <<~EOS
                find_llvm_command(CMAKE_RANLIB llvm-ranlib)
                if(CMAKE_RANLIB MATCHES "NOTFOUND")
                  find_command(VARIABLE CMAKE_RANLIB COMMAND ranlib REQUIRED ON)
                  list(APPEND CMAKE_ARGS -DCMAKE_RANLIB=${CMAKE_RANLIB})
                endif()
              EOS
    inreplace "cmake/tools/SetupLLVM.cmake",
              "    find_llvm_command(LLD_PROGRAM ld.lld)\n",
              <<~EOS
                find_llvm_command(LLD_PROGRAM ld.lld)
                if(LLD_PROGRAM MATCHES "NOTFOUND")
                  find_command(VARIABLE LLD_PROGRAM COMMAND ld.lld REQUIRED ON)
                endif()
              EOS
    inreplace "cmake/tools/SetupLLVM.cmake",
              "    find_llvm_command(CMAKE_DSYMUTIL dsymutil)\n",
              <<~EOS
                find_llvm_command(CMAKE_DSYMUTIL dsymutil)
                if(CMAKE_DSYMUTIL MATCHES "NOTFOUND")
                  find_command(VARIABLE CMAKE_DSYMUTIL COMMAND dsymutil REQUIRED ON)
                  list(APPEND CMAKE_ARGS -DCMAKE_DSYMUTIL=${CMAKE_DSYMUTIL})
                endif()
              EOS
    if OS.linux?
      # Full LTO on Linux CI can fail at the final bun-profile link step.
      inreplace "cmake/Options.cmake",
                "if(RELEASE AND LINUX AND CI AND NOT ENABLE_ASSERTIONS AND NOT ENABLE_ASAN)",
                "if(RELEASE AND LINUX AND CI AND NOT ENABLE_ASSERTIONS AND NOT ENABLE_ASAN " \
                "AND NOT (LINUX AND (ARCH STREQUAL \"aarch64\" OR ARCH STREQUAL \"arm64\" " \
                "OR ARCH STREQUAL \"x86_64\" OR ARCH STREQUAL \"x64\")))"
    end
    # Newer libc++ <ranges> headers break if included after this private/public
    # shim used by Bun's V8 header wrapper.
    inreplace "src/bun.js/bindings/v8/real_v8.h",
              "#define private public",
              "#include <ranges>\n#define private public"

    system buildpath/"bootstrap-bin/bun", "run", "build:release"

    bin.install "build/release/bun"
    bin.install_symlink bin/"bun" => "bunx"

    bash_completion.install "completions/bun.bash" => "bun"
    zsh_completion.install "completions/bun.zsh" => "_bun"
    fish_completion.install "completions/bun.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bun --version")

    (testpath/"hello.ts").write <<~TYPESCRIPT
      console.log("Hello world!");
    TYPESCRIPT

    assert_equal "Hello world!", shell_output("#{bin}/bun run hello.ts").chomp
  end
end
