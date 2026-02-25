class Bun < Formula
  desc "Incredibly fast JavaScript runtime, bundler, transpiler, and package manager"
  homepage "https://bun.sh/"
  url "https://github.com/oven-sh/bun/archive/refs/tags/bun-v1.3.9.tar.gz"
  sha256 "844ee01f43cea34238d29c4637296ce438d61fb48fe2e633d8d27ceb761071f2"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "esbuild" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.12" => :build
  depends_on "rust" => :build

  depends_on "brotli"
  depends_on "c-ares"
  depends_on "hdrhistogram_c"
  depends_on "highway"
  depends_on "libarchive"
  depends_on "libdeflate"
  depends_on "libuv"
  depends_on "lol-html"
  depends_on "ls-hpack"
  depends_on "mimalloc"
  depends_on "openssl@3"
  depends_on "sqlite"
  depends_on "zstd"

  on_macos do
    depends_on "llvm" => :build if MacOS.version < :sequoia
  end

  on_linux do
    depends_on "lld" => :build
    depends_on "llvm" => :build
  end

  resource "picohttpparser" do
    url "https://github.com/h2o/picohttpparser/archive/066d2b1e9ab820703db0837a7255d92d30f0c9f5.tar.gz"
    sha256 "637ff2ab6f5c7f7e05a5b5dc393d5cf2fea8d4754fcaceaaf935ffff5c1323ee"
  end
  resource "nodejs-headers" do
    url "https://nodejs.org/dist/v24.3.0/node-v24.3.0-headers.tar.gz"
    sha256 "045e9bf477cd5db0ec67f8c1a63ba7f784dedfe2c581e3d0ed09b88e9115dd07"
  end
  resource "lezer-cpp" do
    url "https://registry.npmjs.org/@lezer/cpp/-/cpp-1.1.3.tgz"
    sha256 "c03573bc59c1e8458ea365b1bef6c69025ccad499b1c181f1608a8a090894c0b"
  end
  resource "lezer-common" do
    url "https://registry.npmjs.org/@lezer/common/-/common-1.3.0.tgz"
    sha256 "f39d47d2a032de876151f5d1867d2efe8d1b597edb877f19ea8d92ac4925ce5a"
  end
  resource "lezer-highlight" do
    url "https://registry.npmjs.org/@lezer/highlight/-/highlight-1.2.3.tgz"
    sha256 "5257a530b96473efa7dcfd02adf790d71bc4d6f216e77d3b5842fb26f0b674ef"
  end
  resource "lezer-lr" do
    url "https://registry.npmjs.org/@lezer/lr/-/lr-1.4.3.tgz"
    sha256 "22b56fa117f749e07499ad039158c6efac603f3b419966e630fa48e81b61a01f"
  end

  patch :DATA

  def install
    linux_warning_patch_applied = false
    if OS.mac? && MacOS.version < :sequoia
      # Use brewed clang with full C++23 support on older macOS.
      ENV.llvm_clang
    end

    # Populate cmake/sources/*.txt from cmake/Sources.json.  The release
    # tarball ships empty placeholder files; the upstream build expects
    # `scripts/glob-sources.mjs` (a bun script) to have been run beforehand.
    # We replicate that logic in Ruby so the source lists are ready before
    # cmake configure.
    mkdir_p "cmake/sources"
    excludes = %w[
      src/bun.js/bindings/GeneratedBindings.zig
      src/bun.js/bindings/GeneratedJS2Native.zig
    ]
    require "json"
    JSON.parse((buildpath/"cmake/Sources.json").read).each do |entry|
      outfile = buildpath/"cmake/sources"/entry["output"]
      item_excludes = (entry["exclude"] || []) + excludes
      paths = entry["paths"].flat_map { |pat| Dir.glob(buildpath/pat) }
                            .map { |p| Pathname(p).relative_path_from(buildpath).to_s }
                            .reject { |p| item_excludes.include?(p) }
                            .sort
                            .uniq
      outfile.write("#{paths.join("\n")}\n")
    end
    resource("picohttpparser").stage do
      mkdir_p buildpath/"vendor/picohttpparser"
      cp "picohttpparser.c", buildpath/"vendor/picohttpparser/picohttpparser.c"
      cp "picohttpparser.h", buildpath/"vendor/picohttpparser/picohttpparser.h"
    end
    resource("nodejs-headers").stage do
      rm_r buildpath/"vendor/nodejs" if (buildpath/"vendor/nodejs").exist?
      mkdir_p buildpath/"vendor/nodejs"
      cp_r Dir["*"], buildpath/"vendor/nodejs"
      # PrepareNodeHeaders.cmake removes conflicting OpenSSL/libuv headers
      rm_r buildpath/"vendor/nodejs/include/node/openssl" if (buildpath/"vendor/nodejs/include/node/openssl").exist?
      rm_r buildpath/"vendor/nodejs/include/node/uv" if (buildpath/"vendor/nodejs/include/node/uv").exist?
      rm buildpath/"vendor/nodejs/include/node/uv.h" if (buildpath/"vendor/nodejs/include/node/uv.h").exist?
      (buildpath/"vendor/nodejs/include/.node-headers-prepared").write("1")
    end
    # Pre-install @lezer npm packages needed by cppbind.ts (C++ → Zig binding
    # generator). The script auto-runs `bun install` when node_modules is
    # missing, but that hangs inside the Homebrew sandbox (no network).
    %w[lezer-cpp lezer-common lezer-highlight lezer-lr].each do |res|
      scope = res.delete_prefix("lezer-")
      dest = buildpath/"node_modules/@lezer"/scope
      mkdir_p dest
      resource(res).stage { cp_r Dir["*"], dest }
    end
    # ── CMake patches: bootstrap, network, and build tool overrides ──
    inreplace "cmake/tools/SetupBun.cmake",
              "if (NOT CI)",
              <<~CMAKE
                if (NOT EXISTS ${BUN_EXECUTABLE})
                  if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Darwin")
                    if(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "^(arm64|aarch64)$")
                      set(BUN_BOOTSTRAP_FILENAME "bun-darwin-aarch64.zip")
                      set(BUN_BOOTSTRAP_SHA256 "cde6a4edf19cf64909158fa5a464a12026fd7f0d79a4a950c10cf0af04266d85")
                    else()
                      set(BUN_BOOTSTRAP_FILENAME "bun-darwin-x64.zip")
                      set(BUN_BOOTSTRAP_SHA256 "588f4a48740b9a0c366a00f878810ab3ab5e6734d29b7c3cbdd9484b74a007de")
                    endif()
                  elseif(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "^(arm64|aarch64)$")
                    set(BUN_BOOTSTRAP_FILENAME "bun-linux-aarch64.zip")
                    set(BUN_BOOTSTRAP_SHA256 "a2c2862bcc1fd1c0b3a8dcdc8c7efb5e2acd871eb20ed2f17617884ede81c844")
                  else()
                    set(BUN_BOOTSTRAP_FILENAME "bun-linux-x64.zip")
                    set(BUN_BOOTSTRAP_SHA256 "4680e80e44e32aa718560ceae85d22ecfbf2efb8f3641782e35e4b7efd65a1aa")
                  endif()
                  set(BUN_BOOTSTRAP_URL "https://github.com/oven-sh/bun/releases/download/bun-v${VERSION}/${BUN_BOOTSTRAP_FILENAME}")
                  set(BUN_BOOTSTRAP_ARCHIVE "${CACHE_PATH}/${BUN_BOOTSTRAP_FILENAME}")
                  set(BUN_BOOTSTRAP_ROOT "${CACHE_PATH}/bootstrap-bun-${VERSION}")
                  string(REPLACE ".zip" "" BUN_BOOTSTRAP_DIRNAME "${BUN_BOOTSTRAP_FILENAME}")
                  set(BUN_BOOTSTRAP_EXTRACTED "${BUN_BOOTSTRAP_ROOT}/${BUN_BOOTSTRAP_DIRNAME}/bun")
                  if(NOT EXISTS "${BUN_BOOTSTRAP_ARCHIVE}")
                    file(
                      DOWNLOAD "${BUN_BOOTSTRAP_URL}" "${BUN_BOOTSTRAP_ARCHIVE}" SHOW_PROGRESS
                      EXPECTED_HASH "SHA256=${BUN_BOOTSTRAP_SHA256}"
                    )
                  endif()
                  if(NOT EXISTS "${BUN_BOOTSTRAP_EXTRACTED}")
                    file(ARCHIVE_EXTRACT INPUT "${BUN_BOOTSTRAP_ARCHIVE}" DESTINATION "${BUN_BOOTSTRAP_ROOT}")
                  endif()
                  if(NOT EXISTS "${BUN_BOOTSTRAP_EXTRACTED}")
                    message(FATAL_ERROR "Failed to extract bootstrap bun: ${BUN_BOOTSTRAP_EXTRACTED}")
                  endif()
                  set(BUN_EXECUTABLE "${BUN_BOOTSTRAP_EXTRACTED}" CACHE FILEPATH "Bun executable" FORCE)
                  message(STATUS "Using downloaded bootstrap Bun: ${BUN_EXECUTABLE}")
                endif()

                if (NOT CI)
              CMAKE
    setup_bun_guard = 'message(STATUS "Using downloaded bootstrap Bun: ${BUN_EXECUTABLE}")'
    unless (buildpath/"cmake/tools/SetupBun.cmake").read.include?(setup_bun_guard)
      raise "Failed to patch SetupBun.cmake bootstrap fallback"
    end

    # Use vendored Node.js headers instead of downloading
    inreplace "cmake/targets/BuildBun.cmake",
              "set(NODEJS_HEADERS_PATH ${VENDOR_PATH}/nodejs)\n\nregister_command(",
              <<~CMAKE
                set(NODEJS_HEADERS_PATH ${VENDOR_PATH}/nodejs)

                if(EXISTS ${NODEJS_HEADERS_PATH}/include/node/node_version.h)
                  message(STATUS "Using vendored Node.js headers")
                  add_custom_target(bun-node-headers)
                else()

                register_command(
              CMAKE
    node_headers_guard = 'message(STATUS "Using vendored Node.js headers")'
    unless (buildpath/"cmake/targets/BuildBun.cmake").read.include?(node_headers_guard)
      raise "Failed to patch BuildBun.cmake vendored Node.js headers"
    end

    # Avoid network package installs for bun-error and node-fallbacks
    react_refresh_define = %q(--define:process.env.NODE_ENV=\"'development'\")
    {
      "BUN_ERROR"          => "bun-error",
      "BUN_NODE_FALLBACKS" => "node-fallbacks",
    }.each do |prefix, name|
      inreplace "cmake/targets/BuildBun.cmake",
                <<~CMAKE,
                  register_bun_install(
                    CWD
                      ${#{prefix}_SOURCE}
                    NODE_MODULES_VARIABLE
                      #{prefix}_NODE_MODULES
                  )
                CMAKE
                <<~CMAKE
                  set(#{prefix}_NODE_MODULES)
                  message(STATUS "Skipping bun install for #{name}")
                CMAKE
    end
    build_bun_cmake_contents = (buildpath/"cmake/targets/BuildBun.cmake").read
    unless build_bun_cmake_contents.include?('message(STATUS "Skipping bun install for bun-error")')
      raise "Failed to patch BuildBun.cmake bun-error install guard"
    end

    unless build_bun_cmake_contents.include?('message(STATUS "Skipping bun install for node-fallbacks")')
      raise "Failed to patch BuildBun.cmake node-fallbacks install guard"
    end

    inreplace "cmake/targets/BuildBun.cmake",
              <<~CMAKE,
                # This command relies on an older version of `esbuild`, which is why
                # it uses ${BUN_EXECUTABLE} x instead of ${ESBUILD_EXECUTABLE}.
                register_command(
                  TARGET
                    bun-node-fallbacks
                  COMMENT
                    "Building node-fallbacks/*.js"
                  CWD
                    ${BUN_NODE_FALLBACKS_SOURCE}
                  COMMAND
                    ${BUN_EXECUTABLE} ${BUN_FLAGS} run build-fallbacks
                      ${BUN_NODE_FALLBACKS_OUTPUT}
                      ${BUN_NODE_FALLBACKS_SOURCES}
                  SOURCES
                    ${BUN_NODE_FALLBACKS_SOURCES}
                    ${BUN_NODE_FALLBACKS_NODE_MODULES}
                  OUTPUTS
                    ${BUN_NODE_FALLBACKS_OUTPUTS}
                )
              CMAKE
              <<~CMAKE
                # This command relies on an older version of `esbuild`, which is why
                # it uses ${BUN_EXECUTABLE} x instead of ${ESBUILD_EXECUTABLE}.
                if(EXISTS ${BUN_NODE_FALLBACKS_SOURCE}/node_modules/assert)
                  register_command(
                    TARGET
                      bun-node-fallbacks
                    COMMENT
                      "Building node-fallbacks/*.js"
                    CWD
                      ${BUN_NODE_FALLBACKS_SOURCE}
                    COMMAND
                      ${BUN_EXECUTABLE} ${BUN_FLAGS} run build-fallbacks
                        ${BUN_NODE_FALLBACKS_OUTPUT}
                        ${BUN_NODE_FALLBACKS_SOURCES}
                    SOURCES
                      ${BUN_NODE_FALLBACKS_SOURCES}
                      ${BUN_NODE_FALLBACKS_NODE_MODULES}
                    OUTPUTS
                      ${BUN_NODE_FALLBACKS_OUTPUTS}
                  )
                else()
                  message(STATUS "Skipping node-fallbacks/*.js (node_modules not installed)")
                  string(REPLACE ";" " " BUN_NODE_FALLBACKS_OUTPUTS_SHELL "${BUN_NODE_FALLBACKS_OUTPUTS}")
                  register_command(
                    TARGET
                      bun-node-fallbacks
                    COMMENT
                      "Generating placeholder node-fallbacks/*.js"
                    COMMAND
                      /bin/sh -c "mkdir -p ${BUN_NODE_FALLBACKS_OUTPUT} && : > /dev/null && touch ${BUN_NODE_FALLBACKS_OUTPUTS_SHELL}"
                    OUTPUTS
                      ${BUN_NODE_FALLBACKS_OUTPUTS}
                  )
                endif()
              CMAKE
    node_fallbacks_guard = 'message(STATUS "Skipping node-fallbacks/*.js (node_modules not installed)")'
    unless (buildpath/"cmake/targets/BuildBun.cmake").read.include?(node_fallbacks_guard)
      raise "Failed to patch BuildBun.cmake node-fallbacks placeholder guard"
    end

    inreplace "cmake/targets/BuildBun.cmake",
              <<~CMAKE,
                # An embedded copy of react-refresh is used when the user forgets to install it.
                # The library is not versioned alongside React.
                set(BUN_REACT_REFRESH_OUTPUT ${BUN_NODE_FALLBACKS_OUTPUT}/react-refresh.js)
                register_command(
                  TARGET
                    bun-node-fallbacks-react-refresh
                  COMMENT
                    "Building node-fallbacks/react-refresh.js"
                  CWD
                    ${BUN_NODE_FALLBACKS_SOURCE}
                  COMMAND
                    ${BUN_EXECUTABLE} ${BUN_FLAGS} build
                      ${BUN_NODE_FALLBACKS_SOURCE}/node_modules/react-refresh/cjs/react-refresh-runtime.development.js
                      --outfile=${BUN_REACT_REFRESH_OUTPUT}
                      --target=browser
                      --format=cjs
                      --minify
                      #{react_refresh_define}
                  SOURCES
                    ${BUN_NODE_FALLBACKS_SOURCE}/package.json
                    ${BUN_NODE_FALLBACKS_SOURCE}/bun.lock
                    ${BUN_NODE_FALLBACKS_NODE_MODULES}
                  OUTPUTS
                    ${BUN_REACT_REFRESH_OUTPUT}
                )
              CMAKE
              <<~CMAKE
                # An embedded copy of react-refresh is used when the user forgets to install it.
                # The library is not versioned alongside React.
                set(BUN_REACT_REFRESH_OUTPUT ${BUN_NODE_FALLBACKS_OUTPUT}/react-refresh.js)
                if(EXISTS ${BUN_NODE_FALLBACKS_SOURCE}/node_modules/react-refresh/cjs/react-refresh-runtime.development.js)
                  register_command(
                    TARGET
                      bun-node-fallbacks-react-refresh
                    COMMENT
                      "Building node-fallbacks/react-refresh.js"
                    CWD
                      ${BUN_NODE_FALLBACKS_SOURCE}
                    COMMAND
                      ${BUN_EXECUTABLE} ${BUN_FLAGS} build
                        ${BUN_NODE_FALLBACKS_SOURCE}/node_modules/react-refresh/cjs/react-refresh-runtime.development.js
                        --outfile=${BUN_REACT_REFRESH_OUTPUT}
                        --target=browser
                        --format=cjs
                        --minify
                        #{react_refresh_define}
                    SOURCES
                      ${BUN_NODE_FALLBACKS_SOURCE}/package.json
                      ${BUN_NODE_FALLBACKS_SOURCE}/bun.lock
                      ${BUN_NODE_FALLBACKS_NODE_MODULES}
                    OUTPUTS
                      ${BUN_REACT_REFRESH_OUTPUT}
                  )
                else()
                  message(STATUS "Skipping node-fallbacks/react-refresh.js (react-refresh not installed)")
                  register_command(
                    TARGET
                      bun-node-fallbacks-react-refresh
                    COMMENT
                      "Generating placeholder node-fallbacks/react-refresh.js"
                    COMMAND
                      /bin/sh -c "mkdir -p ${BUN_NODE_FALLBACKS_OUTPUT} && : > ${BUN_REACT_REFRESH_OUTPUT}"
                    OUTPUTS
                      ${BUN_REACT_REFRESH_OUTPUT}
                  )
                endif()
              CMAKE
    # Close the else() block for node headers
    inreplace "cmake/targets/BuildBun.cmake",
              <<~CMAKE,
                  OUTPUTS
                    ${NODEJS_HEADERS_PATH}/include/node/node_version.h
                    ${NODEJS_HEADERS_PATH}/include/.node-headers-prepared
                )
              CMAKE
              <<~CMAKE
                  OUTPUTS
                    ${NODEJS_HEADERS_PATH}/include/node/node_version.h
                    ${NODEJS_HEADERS_PATH}/include/.node-headers-prepared
                )
                endif()
              CMAKE
    inreplace "cmake/targets/BuildBun.cmake",
              /(\s+OUTPUTS\n\s+\$\{BUN_BINDGENV2_CPP_OUTPUTS\}\n\s+\$\{BUN_BINDGENV2_ZIG_OUTPUTS\}\n)/,
              "\\1  ALWAYS_RUN\n"
    inreplace "cmake/targets/BuildBun.cmake",
              "--platform=browser\n      --minify",
              "--platform=browser\n      --minify\n      --external:peechy"
    setupllvm_ld_path_pattern = /
      list\(APPEND\s+CMAKE_ARGS\s+-DCMAKE_EXE_LINKER_FLAGS=--ld-path=\$\{LLD_PROGRAM\}\)\n
      \s*list\(APPEND\s+CMAKE_ARGS\s+-DCMAKE_SHARED_LINKER_FLAGS=--ld-path=\$\{LLD_PROGRAM\}\)\n
    /x
    inreplace "cmake/tools/SetupLLVM.cmake",
              setupllvm_ld_path_pattern,
              <<~CMAKE
                if(LLD_PROGRAM)
                  list(APPEND CMAKE_ARGS -DCMAKE_EXE_LINKER_FLAGS=--ld-path=${LLD_PROGRAM})
                  list(APPEND CMAKE_ARGS -DCMAKE_SHARED_LINKER_FLAGS=--ld-path=${LLD_PROGRAM})
                endif()
              CMAKE
    # Keep Bun's warning policy aligned with upstream Buildkite builds while
    # tolerating newer Linux clang diagnostics seen in Homebrew CI.
    warning_line_replacement = <<~CMAKE.chomp
      #{OS.mac? ? "-Wno-vector-conversion" : "-Wno-character-conversion"}
      #{(OS.mac? && MacOS.version < :sequoia) ? "-Wno-dangling-gsl" : "-Wno-dangling-assignment-gsl"}
      -Wno-deprecated-declarations
    CMAKE
    buildbun_cmake = buildpath/"cmake/targets/BuildBun.cmake"
    if buildbun_cmake.read.include?("-Wno-character-conversion")
      inreplace "cmake/targets/BuildBun.cmake",
                "-Wno-character-conversion",
                warning_line_replacement,
                global: true
      linux_warning_patch_applied = true
    end
    if OS.mac? && MacOS.version < :sequoia
      compiler_flags = buildpath/"cmake/CompilerFlags.cmake"
      if compiler_flags.read.include?("-Wno-c23-extensions")
        inreplace "cmake/CompilerFlags.cmake",
                  "-Wno-c23-extensions",
                  "-Wno-c2x-extensions",
                  global: true
      end
      if buildbun_cmake.read.include?("-Wno-c23-extensions")
        inreplace "cmake/targets/BuildBun.cmake",
                  "-Wno-c23-extensions",
                  "-Wno-c2x-extensions",
                  global: true
      end
      if buildbun_cmake.read.include?("-Wno-c++23-lambda-attributes")
        inreplace "cmake/targets/BuildBun.cmake",
                  "-Wno-c++23-lambda-attributes",
                  "",
                  global: true
      end
      if buildbun_cmake.read.include?("-Wno-dangling-assignment-gsl")
        inreplace "cmake/targets/BuildBun.cmake",
                  "-Wno-dangling-assignment-gsl",
                  "-Wno-dangling-gsl",
                  global: true
      end
    end
    bun_error_esbuild_cmd = <<~'CMAKE'.gsub(/^/, "      ")
      bun-error.css
      --outdir=${BUN_ERROR_OUTPUT}
      --define:process.env.NODE_ENV=\"'production'\"
      --minify
      --bundle
      --platform=browser
      --format=esm
    CMAKE
    bun_error_esbuild_replacement = [
      bun_error_esbuild_cmd,
      "      --external:preact",
      "      --external:preact/hooks",
      "      --external:preact/jsx-runtime",
    ].join("\n")
    inreplace "cmake/targets/BuildBun.cmake",
              bun_error_esbuild_cmd,
              bun_error_esbuild_replacement
    # ── WebKit/JSC ABI compatibility patches ──
    # Disable WebKit features bun doesn't use — cmakeconfig.h enables them but
    # required headers (WebGLAny.h, BufferMediaSource.h, DetachedRTCDataChannel.h)
    # are absent.  Patch root.h to override after cmakeconfig.h is included
    # (avoids -Wmacro-redefined with -Werror).
    inreplace "src/bun.js/bindings/root.h",
              '#include "cmakeconfig.h"',
              "#include \"cmakeconfig.h\"\n" \
              "#ifndef USE_BUN_JSC_ADDITIONS\n#define USE_BUN_JSC_ADDITIONS 1\n#endif\n" \
              "#undef ENABLE_WEBGL\n#define ENABLE_WEBGL 0\n" \
              "#undef ENABLE_MEDIA_SOURCE\n#define ENABLE_MEDIA_SOURCE 0\n" \
              "#undef ENABLE_WEB_RTC\n#define ENABLE_WEB_RTC 0\n"
    inreplace "cmake/targets/BuildBun.cmake",
              <<~CMAKE,
                if (NOT WIN32)
                  # Enable precompiled headers
                  # Only enable in these scenarios:
                  # 1. NOT in CI, OR
                  # 2. In CI AND BUN_CPP_ONLY is enabled
                  if(NOT CI OR (CI AND BUN_CPP_ONLY))
                    target_precompile_headers(${bun} PRIVATE
                      "$<$<COMPILE_LANGUAGE:CXX>:${CWD}/src/bun.js/bindings/root.h>"
                    )
                  endif()
                endif()
              CMAKE
              <<~CMAKE
                if (NOT WIN32)
                  message(STATUS "Skipping precompiled headers for Homebrew build")
                endif()
              CMAKE
    inreplace "cmake/targets/BuildBun.cmake",
              <<~CMAKE,
                register_repository(
                  NAME
                    picohttpparser
                  REPOSITORY
                    h2o/picohttpparser
                  COMMIT
                    066d2b1e9ab820703db0837a7255d92d30f0c9f5
                  OUTPUTS
                    picohttpparser.c
                )
              CMAKE
              <<~CMAKE
                if(EXISTS ${VENDOR_PATH}/picohttpparser/picohttpparser.c)
                  message(STATUS "Using vendored picohttpparser")
                else()
                  register_repository(
                    NAME
                      picohttpparser
                    REPOSITORY
                      h2o/picohttpparser
                    COMMIT
                      066d2b1e9ab820703db0837a7255d92d30f0c9f5
                    OUTPUTS
                      picohttpparser.c
                  )
                endif()
              CMAKE
    # Strip JavaScriptCore/ prefix from angle-bracket includes in root.h
    # and JSCInlines.h so the JSC shim directory resolves them correctly.
    %w[
      src/bun.js/bindings/root.h
      src/bun.js/bindings/JSCInlines.h
    ].each do |f|
      inreplace f, %r{#include <JavaScriptCore/([^>]+)>}, '#include <\1>'
    end
    webkit_download_block = <<~CMAKE
      file(
        DOWNLOAD ${WEBKIT_DOWNLOAD_URL} ${CACHE_PATH}/${WEBKIT_FILENAME} SHOW_PROGRESS
        STATUS WEBKIT_DOWNLOAD_STATUS
      )
    CMAKE
    webkit_guarded_download_block = <<~CMAKE
      if (BUN_BOOTSTRAP STREQUAL "OFF")
        message(FATAL_ERROR "BUN_BOOTSTRAP=OFF: WebKit download disabled. Provide a local WEBKIT_PATH.")
      endif()
      file(
        DOWNLOAD ${WEBKIT_DOWNLOAD_URL} ${CACHE_PATH}/${WEBKIT_FILENAME} SHOW_PROGRESS
        STATUS WEBKIT_DOWNLOAD_STATUS
      )
    CMAKE
    inreplace "cmake/tools/SetupWebKit.cmake", webkit_download_block, webkit_guarded_download_block
    inreplace "cmake/tools/SetupWebKit.cmake",
              "set(WEBKIT_LIB_PATH ${WEBKIT_PATH}/lib)",
              <<~CMAKE
                if(EXISTS ${WEBKIT_PATH}/lib/libWTF.a)
                  set(WEBKIT_LIB_PATH ${WEBKIT_PATH}/lib)
                elseif(EXISTS ${WEBKIT_PATH}/libWTF.a)
                  set(WEBKIT_LIB_PATH ${WEBKIT_PATH})
                else()
                  set(WEBKIT_LIB_PATH ${WEBKIT_PATH}/lib)
                endif()
              CMAKE
    # Create a shim directory so #include <JavaScriptCore/X.h> resolves to PrivateHeaders/X.h.
    # The bun source has ~1400 includes using this pattern and the system framework doesn't
    # have these private headers; the shim avoids rewriting every include individually.
    jsc_shim = buildpath/"jsc-include-shim"
    jsc_bare_shim = buildpath/"jsc-bare-shim"
    patched_ph_dir = buildpath/"patched-privateheaders"
    mkdir_p jsc_shim
    mkdir_p jsc_bare_shim
    # Replace framework PrivateHeaders path with our patched copy so that
    # transitive #include "Heap.h" from JSC headers picks up the ABI fix.
    inreplace "cmake/tools/SetupWebKit.cmake",
              "    ${WEBKIT_PATH}/JavaScriptCore/PrivateHeaders\n",
              <<~CMAKE
                ${WEBKIT_PATH}/JavaScriptCore.framework/Headers
                #{patched_ph_dir}
                #{jsc_bare_shim}
                #{jsc_shim}
              CMAKE
    # Populate the shim at configure time: create a JavaScriptCore directory containing
    # symlinks to headers from PrivateHeaders, public Headers, and Source tree.
    # This resolves all ~1400 #include <JavaScriptCore/X.h> in bun source at once.
    inreplace "cmake/tools/SetupWebKit.cmake",
              "set(WEBKIT_INCLUDE_PATH ${WEBKIT_PATH}/include)",
              <<~CMAKE.chomp
                set(WEBKIT_INCLUDE_PATH ${WEBKIT_PATH}/include)
                # Create JavaScriptCore include shim for angle-bracket private header includes
                set(JSC_SHIM_DIR "#{jsc_shim}/JavaScriptCore")
                if(NOT EXISTS "${JSC_SHIM_DIR}")
                  file(MAKE_DIRECTORY "${JSC_SHIM_DIR}")
                  # Link PrivateHeaders (bulk of needed headers)
                  # Use patched-privateheaders instead of framework PrivateHeaders
                  # so that transitive #include "Heap.h" resolves to the ABI-patched copy.
                  foreach(HDIR "#{patched_ph_dir}"
                               "${WEBKIT_PATH}/JavaScriptCore/PrivateHeaders"
                               "${WEBKIT_PATH}/JavaScriptCore.framework/Headers"
                               "${WEBKIT_PATH}/JavaScriptCore/Headers"
                               "${WEBKIT_INCLUDE_PATH}/JavaScriptCore")
                    if(EXISTS "${HDIR}")
                      file(GLOB _hdrs "${HDIR}/*.h")
                      foreach(_h ${_hdrs})
                        get_filename_component(_name "${_h}" NAME)
                        if(NOT EXISTS "${JSC_SHIM_DIR}/${_name}")
                          file(CREATE_LINK "${_h}" "${JSC_SHIM_DIR}/${_name}" SYMBOLIC)
                        endif()
                      endforeach()
                    endif()
                  endforeach()
                  # Link Source tree headers not in PrivateHeaders (e.g. runtime inlines)
                  set(JSC_SRC "${WEBKIT_PATH}/../../Source/JavaScriptCore")
                  if(EXISTS "${JSC_SRC}")
                    foreach(SUBDIR runtime API heap inspector dfg parser bytecompiler bytecode jit llint assembler interpreter b3 yarr wasm debugger domjit disassembler profiler generator builtins ftl)
                      if(EXISTS "${JSC_SRC}/${SUBDIR}")
                        file(GLOB_RECURSE _hdrs "${JSC_SRC}/${SUBDIR}/*.h")
                        list(FILTER _hdrs EXCLUDE REGEX "/glib/")
                        foreach(_h ${_hdrs})
                          get_filename_component(_name "${_h}" NAME)
                          if(NOT EXISTS "${JSC_SHIM_DIR}/${_name}")
                            file(CREATE_LINK "${_h}" "${JSC_SHIM_DIR}/${_name}" SYMBOLIC)
                          endif()
                        endforeach()
                      endif()
                    endforeach()
                  endif()
                  message(STATUS "Created JSC include shim directory: ${JSC_SHIM_DIR}")
                endif()
                # Create a bare-include shim for Source tree headers not in PrivateHeaders.
                # PrivateHeaders headers use bare #include "X.h" to include internal
                # headers; we can't add Source/runtime as -I (causes redefinitions for
                # overlapping headers), so we symlink only the MISSING headers into a
                # separate shim directory that's in the -I path.
                set(JSC_BARE_SHIM "#{jsc_bare_shim}")
                # Prebuilt WebKit tarballs only ship include/JavaScriptCore.
                # Seed the bare-include shim from there so stripped includes
                # like <JSCJSValue.h> still resolve when Source/ is absent.
                if(EXISTS "${WEBKIT_INCLUDE_PATH}/JavaScriptCore")
                  file(GLOB _pkg_hdrs "${WEBKIT_INCLUDE_PATH}/JavaScriptCore/*.h")
                  foreach(_pkg_h ${_pkg_hdrs})
                    get_filename_component(_pkg_name "${_pkg_h}" NAME)
                    if(NOT EXISTS "${JSC_BARE_SHIM}/${_pkg_name}")
                      file(CREATE_LINK "${_pkg_h}" "${JSC_BARE_SHIM}/${_pkg_name}" SYMBOLIC)
                    endif()
                  endforeach()
                endif()
                set(JSC_SRC2 "${WEBKIT_PATH}/../../Source/JavaScriptCore")
                if(EXISTS "${JSC_SRC2}")
                  # Collect all PrivateHeaders names to skip
                  set(_ph_names)
                  foreach(PH_DIR2 "${WEBKIT_PATH}/JavaScriptCore.framework/PrivateHeaders"
                                  "${WEBKIT_PATH}/JavaScriptCore/PrivateHeaders"
                                  "${WEBKIT_INCLUDE_PATH}/JavaScriptCore")
                    if(EXISTS "${PH_DIR2}")
                      file(GLOB _ph_hdrs "${PH_DIR2}/*.h")
                      foreach(_ph ${_ph_hdrs})
                        get_filename_component(_pname "${_ph}" NAME)
                        list(APPEND _ph_names "${_pname}")
                      endforeach()
                    endif()
                  endforeach()
                  # Symlink Source tree headers that are NOT in PrivateHeaders
                  foreach(SUBDIR2 runtime API heap inspector dfg parser bytecompiler bytecode jit llint assembler interpreter b3 yarr wasm debugger domjit disassembler profiler generator builtins ftl)
                    if(EXISTS "${JSC_SRC2}/${SUBDIR2}")
                      file(GLOB_RECURSE _src_hdrs2 "${JSC_SRC2}/${SUBDIR2}/*.h")
                      list(FILTER _src_hdrs2 EXCLUDE REGEX "/glib/")
                      foreach(_sh2 ${_src_hdrs2})
                        get_filename_component(_sn2 "${_sh2}" NAME)
                        if(NOT "${_sn2}" IN_LIST _ph_names)
                          if(NOT EXISTS "${JSC_BARE_SHIM}/${_sn2}")
                            file(CREATE_LINK "${_sh2}" "${JSC_BARE_SHIM}/${_sn2}" SYMBOLIC)
                          endif()
                        endif()
                      endforeach()
                    endif()
                  endforeach()
                  message(STATUS "Created JSC bare-include shim: ${JSC_BARE_SHIM}")
                endif()
                include_directories("#{jsc_bare_shim}")
                include_directories("#{jsc_shim}")
              CMAKE
    # JSCOnly mode strips PLATFORM(COCOA) but bun uses REMOTE_INSPECTOR with
    # the socket transport. Tell the WTF headers to pick the socket variant.
    inreplace "cmake/targets/BuildBun.cmake",
              "BUILDING_JSCONLY__",
              "BUILDING_JSCONLY__\n  USE_INSPECTOR_SOCKET_SERVER=1"
    inreplace "cmake/Globals.cmake",
              "  register_command(\n    COMMENT\n      ${NPM_COMMENT}\n",
              <<~CMAKE
                if (BUN_BOOTSTRAP STREQUAL "OFF" OR BUN_EXECUTABLE STREQUAL "BUN_BOOTSTRAP_DISABLED")
                  message(STATUS "BUN_BOOTSTRAP=OFF: skipping JS dependency install for ${NPM_CWD}.")
                  return()
                endif()
                register_command(
                  COMMENT
                    ${NPM_COMMENT}
              CMAKE
    inreplace "cmake/Globals.cmake",
              /function\(register_repository\)/,
              <<~CMAKE
                function(register_repository)
                  if (BUN_BOOTSTRAP STREQUAL "OFF" OR BUN_EXECUTABLE STREQUAL "BUN_BOOTSTRAP_DISABLED")
                    message(FATAL_ERROR "BUN_BOOTSTRAP=OFF: external repository downloads are disabled.")
                  endif()
              CMAKE
    # Tarballs have no .git metadata, so fall back to package version for
    # UWS/USOCKETS version defines instead of "unknown".
    inreplace "cmake/tools/GenerateDependencyVersions.cmake",
              'set(BUN_GIT_SHA "unknown")',
              'set(BUN_GIT_SHA "${BUN_VERSION_STRING}")'
    # ── System dependency patches: USE_SYSTEM_* for Homebrew deps ──
    inreplace "cmake/targets/CloneZstd.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_ZSTD "Use system zstd" OFF)
                if(USE_SYSTEM_ZSTD)
                  message(STATUS "Using system zstd")
                  add_custom_target(clone-zstd)
                  return()
                endif()
                register_repository(
              CMAKE
    inreplace "cmake/tools/SetupZig.cmake",
              "register_command(",
              <<~CMAKE
                option(USE_SYSTEM_ZIG "Use system Zig from PATH" OFF)
                if (USE_SYSTEM_ZIG)
                  unset(ZIG_EXECUTABLE)
                  unset(ZIG_EXECUTABLE CACHE)
                  find_program(ZIG_EXECUTABLE zig REQUIRED)
                  set(CMAKE_ZIG_FLAGS)
                  add_custom_target(clone-zig)
                  message(STATUS "Using system Zig: ${ZIG_EXECUTABLE}")
                  return()
                endif()
                register_command(
              CMAKE
    inreplace "cmake/tools/SetupZig.cmake",
              <<~CMAKE,
                if(WIN32 AND DEFAULT_ZIG_OPTIMIZE STREQUAL "ReleaseFast")
                  set(DEFAULT_ZIG_OPTIMIZE "ReleaseSafe")
                endif()
              CMAKE
              <<~CMAKE
                if(WIN32 AND DEFAULT_ZIG_OPTIMIZE STREQUAL "ReleaseFast")
                  set(DEFAULT_ZIG_OPTIMIZE "ReleaseSafe")
                endif()
                if(LINUX AND DEFAULT_ZIG_OPTIMIZE STREQUAL "ReleaseFast")
                  set(DEFAULT_ZIG_OPTIMIZE "ReleaseSafe")
                endif()
              CMAKE
    inreplace "cmake/tools/SetupEsbuild.cmake",
              "if(CMAKE_HOST_WIN32)",
              <<~CMAKE
                option(USE_SYSTEM_ESBUILD "Use system esbuild from PATH" OFF)
                if(USE_SYSTEM_ESBUILD)
                  find_program(ESBUILD_EXECUTABLE esbuild REQUIRED)
                  message(STATUS "Using system esbuild: ${ESBUILD_EXECUTABLE}")
                  return()
                endif()
                if(CMAKE_HOST_WIN32)
              CMAKE
    inreplace "cmake/targets/BuildZstd.cmake",
              "register_cmake_command(",
              <<~CMAKE
                option(USE_SYSTEM_ZSTD "Use system zstd" OFF)
                if(USE_SYSTEM_ZSTD)
                  find_library(ZSTD_LIBRARY NAMES zstd REQUIRED)
                  find_path(ZSTD_INCLUDE_DIR NAMES zstd.h REQUIRED)
                  add_library(zstd STATIC IMPORTED GLOBAL)
                  set_target_properties(zstd PROPERTIES
                    IMPORTED_LOCATION ${ZSTD_LIBRARY}
                    INTERFACE_INCLUDE_DIRECTORIES ${ZSTD_INCLUDE_DIR}
                  )
                  return()
                endif()
                register_cmake_command(
              CMAKE
    # ── OpenSSL 3 / BoringSSL compatibility patches ──
    # When using system OpenSSL (USE_SYSTEM_BORINGSSL=ON), the usockets
    # crypto code uses BoringSSL-specific APIs that don't exist in OpenSSL 3.
    # Add compatibility shims so the code compiles against either library.
    inreplace "packages/bun-usockets/src/crypto/openssl.c",
              "#include <openssl/ssl.h>",
              <<~C
                #include <openssl/ssl.h>
                #ifndef OPENSSL_IS_BORINGSSL
                /* OpenSSL 3 compat: suppress deprecated DH API warnings */
                #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
                /* OpenSSL 3 compat: OPENSSL_PUT_ERROR is BoringSSL-only */
                #include <openssl/err.h>
                #define OPENSSL_PUT_ERROR(lib, code) ERR_raise(ERR_LIB_##lib, code)
                /* OpenSSL 3 compat: renegotiation mode is BoringSSL-only */
                enum ssl_renegotiate_mode_t { ssl_renegotiate_never = 0, ssl_renegotiate_explicit = 1 };
                static inline void SSL_set_renegotiate_mode(SSL *ssl, enum ssl_renegotiate_mode_t mode) { (void)ssl; (void)mode; }
                #ifndef SSL_ERROR_WANT_RENEGOTIATE
                #define SSL_ERROR_WANT_RENEGOTIATE (-1)
                #endif
                #endif /* OPENSSL_IS_BORINGSSL */
              C
    inreplace "cmake/targets/BuildBoringSSL.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_BORINGSSL "Use system OpenSSL libraries" OFF)
                if(USE_SYSTEM_BORINGSSL)
                  find_library(CRYPTO_LIBRARY NAMES crypto REQUIRED)
                  find_library(SSL_LIBRARY NAMES ssl REQUIRED)
                  find_path(OPENSSL_INCLUDE_DIR NAMES openssl/ssl.h REQUIRED)
                  add_library(crypto UNKNOWN IMPORTED GLOBAL)
                  set_target_properties(crypto PROPERTIES
                    IMPORTED_LOCATION ${CRYPTO_LIBRARY}
                    INTERFACE_INCLUDE_DIRECTORIES ${OPENSSL_INCLUDE_DIR}
                  )
                  add_library(ssl UNKNOWN IMPORTED GLOBAL)
                  set_target_properties(ssl PROPERTIES
                    IMPORTED_LOCATION ${SSL_LIBRARY}
                    INTERFACE_INCLUDE_DIRECTORIES ${OPENSSL_INCLUDE_DIR}
                  )
                  add_library(decrepit INTERFACE IMPORTED GLOBAL)
                  target_link_libraries(decrepit INTERFACE crypto)
                  target_include_directories(${bun} PRIVATE ${OPENSSL_INCLUDE_DIR})
                  target_link_libraries(${bun} PRIVATE ${CRYPTO_LIBRARY} ${SSL_LIBRARY})
                  message(STATUS "Using system OpenSSL for BoringSSL targets")
                  return()
                endif()
                register_repository(
              CMAKE
    inreplace "cmake/targets/BuildBrotli.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_BROTLI "Use system brotli" OFF)
                if(USE_SYSTEM_BROTLI)
                  find_library(BROTLICOMMON_LIBRARY NAMES brotlicommon REQUIRED)
                  find_library(BROTLIDEC_LIBRARY NAMES brotlidec REQUIRED)
                  find_library(BROTLIENC_LIBRARY NAMES brotlienc REQUIRED)
                  find_path(BROTLI_INCLUDE_DIR NAMES brotli/decode.h REQUIRED)
                  target_include_directories(${bun} PRIVATE ${BROTLI_INCLUDE_DIR})
                  target_link_libraries(${bun} PRIVATE ${BROTLICOMMON_LIBRARY} ${BROTLIDEC_LIBRARY} ${BROTLIENC_LIBRARY})
                  message(STATUS "Using system brotli")
                  return()
                endif()
                register_repository(
              CMAKE
    inreplace "cmake/targets/BuildCares.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_CARES "Use system c-ares" OFF)
                if(USE_SYSTEM_CARES)
                  find_library(CARES_LIBRARY NAMES cares REQUIRED)
                  find_path(CARES_INCLUDE_DIR NAMES ares.h REQUIRED)
                  add_library(cares UNKNOWN IMPORTED GLOBAL)
                  set_target_properties(cares PROPERTIES
                    IMPORTED_LOCATION ${CARES_LIBRARY}
                    INTERFACE_INCLUDE_DIRECTORIES ${CARES_INCLUDE_DIR}
                  )
                  add_library(c-ares INTERFACE IMPORTED GLOBAL)
                  target_link_libraries(c-ares INTERFACE cares)
                  message(STATUS "Using system c-ares")
                  return()
                endif()
                register_repository(
              CMAKE
    inreplace "cmake/targets/BuildHighway.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_HIGHWAY "Use system highway" OFF)
                if(USE_SYSTEM_HIGHWAY)
                  find_library(HWY_LIBRARY NAMES hwy REQUIRED)
                  find_path(HWY_INCLUDE_DIR NAMES hwy/highway.h REQUIRED)
                  add_library(highway UNKNOWN IMPORTED GLOBAL)
                  set_target_properties(highway PROPERTIES
                    IMPORTED_LOCATION ${HWY_LIBRARY}
                    INTERFACE_INCLUDE_DIRECTORIES ${HWY_INCLUDE_DIR}
                  )
                  message(STATUS "Using system highway")
                  return()
                endif()
                register_repository(
              CMAKE
    inreplace "cmake/targets/BuildLibDeflate.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_LIBDEFLATE "Use system libdeflate" OFF)
                if(USE_SYSTEM_LIBDEFLATE)
                  find_library(LIBDEFLATE_LIBRARY NAMES deflate libdeflate REQUIRED)
                  find_path(LIBDEFLATE_INCLUDE_DIR NAMES libdeflate.h REQUIRED)
                  add_library(libdeflate UNKNOWN IMPORTED GLOBAL)
                  set_target_properties(libdeflate PROPERTIES
                    IMPORTED_LOCATION ${LIBDEFLATE_LIBRARY}
                    INTERFACE_INCLUDE_DIRECTORIES ${LIBDEFLATE_INCLUDE_DIR}
                  )
                  message(STATUS "Using system libdeflate")
                  return()
                endif()
                register_repository(
              CMAKE
    inreplace "cmake/targets/BuildLibArchive.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_LIBARCHIVE "Use system libarchive" OFF)
                if(USE_SYSTEM_LIBARCHIVE)
                  find_package(PkgConfig REQUIRED)
                  pkg_check_modules(LIBARCHIVE REQUIRED IMPORTED_TARGET libarchive)
                  add_library(libarchive INTERFACE IMPORTED GLOBAL)
                  target_link_libraries(libarchive INTERFACE PkgConfig::LIBARCHIVE)
                  message(STATUS "Using system libarchive")
                  return()
                endif()
                register_repository(
              CMAKE
    inreplace "cmake/targets/BuildHdrHistogram.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_HDRHISTOGRAM "Use system hdrhistogram_c" OFF)
                if(USE_SYSTEM_HDRHISTOGRAM)
                  find_library(HDR_HISTOGRAM_LIBRARY NAMES hdr_histogram hdr_histogram_static REQUIRED)
                  find_path(HDR_HISTOGRAM_INCLUDE_DIR NAMES hdr/hdr_histogram.h REQUIRED)
                  add_library(hdrhistogram INTERFACE IMPORTED GLOBAL)
                  target_link_libraries(hdrhistogram INTERFACE ${HDR_HISTOGRAM_LIBRARY})
                  target_include_directories(hdrhistogram INTERFACE ${HDR_HISTOGRAM_INCLUDE_DIR})
                  message(STATUS "Using system hdrhistogram_c")
                  return()
                endif()
                register_repository(
              CMAKE
    inreplace "cmake/targets/BuildLolHtml.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_LOLHTML "Use system lol-html" OFF)
                if(USE_SYSTEM_LOLHTML)
                  find_package(PkgConfig REQUIRED)
                  pkg_check_modules(LOLHTML REQUIRED IMPORTED_TARGET lol-html)
                  target_link_libraries(${bun} PRIVATE PkgConfig::LOLHTML)
                  message(STATUS "Using system lol-html")
                  return()
                endif()
                register_repository(
              CMAKE
    inreplace "cmake/targets/BuildLshpack.cmake",
              <<~CMAKE,
                register_repository(
                  NAME
                    lshpack
                  REPOSITORY
                    litespeedtech/ls-hpack
                  COMMIT
                    8905c024b6d052f083a3d11d0a169b3c2735c8a1
                )
              CMAKE
              <<~CMAKE
                option(USE_SYSTEM_LSHPACK "Use system ls-hpack" OFF)
                if(USE_SYSTEM_LSHPACK)
                  find_library(LSHPACK_LIBRARY NAMES ls-hpack REQUIRED)
                  find_path(LSHPACK_INCLUDE_DIR NAMES lshpack.h REQUIRED)
                  add_custom_target(lshpack)
                  target_include_directories(${bun} PRIVATE ${LSHPACK_INCLUDE_DIR})
                  target_link_libraries(${bun} PRIVATE ${LSHPACK_LIBRARY})
                  message(STATUS "Using system ls-hpack")
                  return()
                endif()
                if(EXISTS ${VENDOR_PATH}/lshpack/CMakeLists.txt)
                  message(STATUS "Using vendored ls-hpack")
                else()
                  register_repository(
                    NAME
                      lshpack
                    REPOSITORY
                      litespeedtech/ls-hpack
                    COMMIT
                      8905c024b6d052f083a3d11d0a169b3c2735c8a1
                  )
                endif()
              CMAKE
    inreplace "cmake/targets/BuildLshpack.cmake",
              "-DLSHPACK_XXH=ON",
              <<~CMAKE.chomp
                -DLSHPACK_XXH=ON
                    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
              CMAKE
    inreplace "cmake/targets/BuildMimalloc.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_MIMALLOC "Use system mimalloc" OFF)
                if(USE_SYSTEM_MIMALLOC)
                  find_library(MIMALLOC_LIBRARY NAMES mimalloc REQUIRED)
                  find_path(MIMALLOC_INCLUDE_DIR NAMES mimalloc.h REQUIRED)
                  target_include_directories(${bun} PRIVATE ${MIMALLOC_INCLUDE_DIR})
                  target_link_libraries(${bun} PRIVATE ${MIMALLOC_LIBRARY})
                  message(STATUS "Using system mimalloc")
                  return()
                endif()
                register_repository(
              CMAKE
    inreplace "cmake/targets/BuildZlib.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_ZLIB "Use system zlib" OFF)
                if(USE_SYSTEM_ZLIB)
                  find_package(ZLIB REQUIRED)
                  add_library(zlib INTERFACE IMPORTED GLOBAL)
                  target_link_libraries(zlib INTERFACE ZLIB::ZLIB)
                  message(STATUS "Using system zlib")
                  return()
                endif()
                register_repository(
              CMAKE

    args = %w[
      -GNinja
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_AR=/usr/bin/ar
      -DCMAKE_RANLIB=/usr/bin/ranlib
      -DUSE_SYSTEM_LIBUV=ON
      -DUSE_SYSTEM_SQLITE=ON
      -DUSE_SYSTEM_BORINGSSL=ON
      -DUSE_SYSTEM_BROTLI=ON
      -DUSE_SYSTEM_CARES=ON
      -DUSE_SYSTEM_HDRHISTOGRAM=ON
      -DUSE_SYSTEM_HIGHWAY=ON
      -DUSE_SYSTEM_LIBARCHIVE=ON
      -DUSE_SYSTEM_LIBDEFLATE=ON
      -DUSE_SYSTEM_LOLHTML=ON
      -DUSE_SYSTEM_MIMALLOC=ON
      -DUSE_SYSTEM_ESBUILD=ON
      -DUSE_SYSTEM_LSHPACK=ON
      -DUSE_SYSTEM_ZLIB=ON
      -DUSE_SYSTEM_ZSTD=ON
      -DENABLE_TINYCC=OFF
      -DENABLE_BASELINE=ON
      -DENABLE_CANARY=OFF
      -DCMAKE_VERBOSE_MAKEFILE=ON
      -DCMAKE_DSYMUTIL=dsymutil
    ]

    # Use system bun for codegen if available (avoids flaky bootstrap download)
    system_bun = Pathname("#{Dir.home}/.bun/bin/bun")
    args << "-DBUN_EXECUTABLE=#{system_bun}" if system_bun.executable?

    if OS.linux?
      llvm_bin = Formula["llvm"].opt_bin
      lld_program = Formula["lld"].opt_bin/"ld.lld"
      lld_program = llvm_bin/"ld.lld" unless lld_program.exist?
      odie "Unable to find ld.lld for Linux build" unless lld_program.exist?
      linker_program = lld_program.to_s
      args << "-DABI=gnu"
      args << "-DCMAKE_C_COMPILER=#{llvm_bin}/clang"
      args << "-DCMAKE_CXX_COMPILER=#{llvm_bin}/clang++"
      args << "-DCMAKE_AR=#{llvm_bin}/llvm-ar"
      args << "-DCMAKE_RANLIB=#{llvm_bin}/llvm-ranlib"
      args << "-DCMAKE_LINKER=#{linker_program}"
      # Use ld.lld to avoid ld.gold LLVM plugin failures on Linux CI builds.
      args << "-DLLD_PROGRAM=#{linker_program}"
      args << "-DCMAKE_EXE_LINKER_FLAGS=--ld-path=#{linker_program}"
      args << "-DCMAKE_SHARED_LINKER_FLAGS=--ld-path=#{linker_program}"
      # Zig ReleaseFast is unstable/OOM on Linux arm64 in CI; use ReleaseSafe.
      args << "-DZIG_OPTIMIZE=ReleaseSafe"
      unless linux_warning_patch_applied
        linux_warning_flags = "-Wno-dangling-assignment-gsl " \
                              "-Wno-character-conversion " \
                              "-Wno-deprecated-declarations"
        args << "-DCMAKE_CXX_FLAGS=#{linux_warning_flags}"
      end
    end

    webkit_path = ENV["HOMEBREW_BUN_WEBKIT_PATH"].to_s
    webkit_candidates = if webkit_path.empty?
      [
        Pathname("vendor/WebKit/WebKitBuild/Release/lib/libWTF.a"),
        Pathname("vendor/WebKit/WebKitBuild/Release/libWTF.a"),
      ]
    else
      args << "-DWEBKIT_PATH=#{webkit_path}"
      [
        Pathname(webkit_path)/"lib/libWTF.a",
        Pathname(webkit_path)/"libWTF.a",
        Pathname(webkit_path)/"usr/local/lib/libWTF.a",
        Pathname(webkit_path)/"WebKitBuild/Release/lib/libWTF.a",
        Pathname(webkit_path)/"WebKitBuild/Release/libWTF.a",
      ]
    end
    webkit_local = webkit_candidates.any?(&:exist?)
    if webkit_local
      args << "-DWEBKIT_LOCAL=ON"
    elsif webkit_path.empty?
      args << "-DWEBKIT_LOCAL=OFF"
      opoo "Local WebKit static libs not found; falling back to upstream WebKit download."
    else
      odie "HOMEBREW_BUN_WEBKIT_PATH is set but local WebKit static libs are missing (libWTF.a)."
    end

    # ABI fix: the prebuilt WebKit library was compiled with PORT=Mac which
    # sets USE(FOUNDATION)=1, adding two data members to JSC::Heap:
    #   Vector<RetainPtr<CFTypeRef>> m_delayedReleaseObjects  (16 bytes)
    #   unsigned m_delayedReleaseRecursionCount               ( 4 bytes)
    # Bun compiles with BUILDING_JSCONLY__ → USE(FOUNDATION)=0 → those 20
    # bytes of members are absent.  Combined with alignment this shifts every
    # VM field after `heap` by 16 bytes → segfault in BunBuiltinNames.
    #
    # A simple abi-shim directory doesn't work because JSC headers do
    # #include "Heap.h" and resolve it relative to their own directory
    # (PrivateHeaders/) before checking the -I include path.  Instead, copy
    # the entire PrivateHeaders directory locally, patch Heap.h in that copy,
    # and replace the framework PrivateHeaders include path with our copy.
    unless webkit_path.empty?
      fw_private = Pathname(webkit_path)/"JavaScriptCore.framework/PrivateHeaders"
      if fw_private.directory?
        patched_ph = buildpath/"patched-privateheaders"
        cp_r fw_private, patched_ph
        inreplace patched_ph/"Heap.h", <<~ORIG.chomp, <<~PATCHED.chomp
          #if USE(FOUNDATION)
              Vector<RetainPtr<CFTypeRef>> m_delayedReleaseObjects;
              unsigned m_delayedReleaseRecursionCount { 0 };
          #endif
        ORIG
          #if USE(FOUNDATION)
              Vector<RetainPtr<CFTypeRef>> m_delayedReleaseObjects;
              unsigned m_delayedReleaseRecursionCount { 0 };
          #elif !defined(JSC_GLIB_API_ENABLED)
              // ABI padding: prebuilt WebKit (PORT=Mac) has USE(FOUNDATION)=1.
              // Match layout: Vector<> is {T*,uint,uint} = 16 bytes + unsigned = 4.
              void* m_abiPadBuf_ { nullptr };
              unsigned m_abiPadCap_ { 0 };
              unsigned m_abiPadSize_ { 0 };
              unsigned m_abiPadRecursion_ { 0 };
          #endif
        PATCHED
      end
    end

    # build.zig hardcodes vendor/zstd/lib for zstd.h include path used by
    # translate-c.  Point it at the system zstd when using USE_SYSTEM_ZSTD.
    mkdir_p "vendor/zstd"
    ln_s Formula["zstd"].opt_include, "vendor/zstd/lib"

    # Linux builds are memory intensive (bun-profile compile frequently OOMs).
    # Serialize the build to keep peak RSS below CI limits.
    build_args = []
    if OS.linux?
      ENV.deparallelize
      ENV["CMAKE_BUILD_PARALLEL_LEVEL"] = "1"
      build_args = ["--", "-j1"]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args

    # Generate codegen files first — they are Ninja build targets, not
    # produced during cmake configure.
    system "cmake", "--build", "build", "--target", "bun-zig-generated-classes", *build_args

    # root_certs.cpp and root_certs_darwin.cpp also use BoringSSL-specific APIs.
    # Add OpenSSL 3 compat shims to root_certs.cpp (includes + OPENSSL_PUT_ERROR + ERR_R_MALLOC_FAILURE).
    inreplace "packages/bun-usockets/src/crypto/root_certs.cpp",
              '#include "./root_certs.h"',
              <<~CPP.chomp
                #include "./root_certs.h"
                #include <openssl/err.h>
                #include <openssl/pem.h>
                #ifndef OPENSSL_IS_BORINGSSL
                #define OPENSSL_PUT_ERROR(lib, code) ERR_raise(ERR_LIB_##lib, code)
                #endif
                #ifndef ERR_R_MALLOC_FAILURE
                #define ERR_R_MALLOC_FAILURE 3
                #endif
              CPP
    # root_certs_darwin.cpp needs <initializer_list> and <openssl/x509v3.h> for X509_check_ca.
    inreplace "packages/bun-usockets/src/crypto/root_certs_darwin.cpp",
              "#include <openssl/x509.h>",
              <<~CPP.chomp
                #include <initializer_list>
                #include <openssl/x509.h>
                #include <openssl/x509v3.h>
              CPP
    # root_certs_linux.cpp uses ERR_clear_error and needs openssl/err.h.
    inreplace "packages/bun-usockets/src/crypto/root_certs_linux.cpp",
              "#include <openssl/pem.h>",
              "#include <openssl/pem.h>\n#include <openssl/err.h>"
    # Suppress deprecated warnings in headers using deprecated OpenSSL 3
    # functions (RSA_free, EC_KEY_free, DH_free, etc.) that are still functional.
    %w[
      src/bun.js/bindings/webcrypto/OpenSSLCryptoUniquePtr.h
      src/bun.js/bindings/ncrypto.h
    ].each do |f|
      inreplace f, "#pragma once", <<~CPP.chomp
        #pragma once
        #ifndef OPENSSL_IS_BORINGSSL
        #pragma GCC diagnostic push
        #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        #endif
      CPP
    end
    # JSX509CertificatePrototype.cpp uses X509_CHECK_FLAG_* constants which
    # are defined in <openssl/x509v3.h>, not <openssl/x509.h>.
    inreplace "src/bun.js/bindings/JSX509CertificatePrototype.cpp",
              '#include "ncrypto.h"',
              <<~CPP.chomp
                #include "ncrypto.h"
                #include <openssl/x509v3.h>
              CPP
    # NodeTLS.cpp includes BoringSSL-specific openssl/base.h; guard it.
    inreplace "src/bun.js/bindings/NodeTLS.cpp",
              '#include "openssl/base.h"',
              <<~CPP.chomp
                #ifdef OPENSSL_IS_BORINGSSL
                #include "openssl/base.h"
                #endif
              CPP
    # Guard BoringSSL-only headers: replace with guarded includes for OpenSSL 3.
    {
      "openssl/mem.h"        => ["#include <stdlib.h>"],
      "openssl/curve25519.h" => [],
    }.each do |header, fallbacks|
      guard = "#ifdef OPENSSL_IS_BORINGSSL\n#include <#{header}>"
      guard += "\n#else\n#{fallbacks.join("\n")}" unless fallbacks.empty?
      guard += "\n#endif"
      files = case header
      when "openssl/mem.h"
        %w[
          src/bun.js/bindings/AsymmetricKeyValue.cpp
          src/bun.js/bindings/node/crypto/node_crypto_binding.cpp
          src/bun.js/bindings/dh-primes.h
          src/bun.js/bindings/webcrypto/CryptoAlgorithmRSA_OAEPOpenSSL.cpp
        ]
      when "openssl/curve25519.h"
        %w[
          src/bun.js/bindings/AsymmetricKeyValue.cpp
          src/bun.js/bindings/node/crypto/node_crypto_binding.cpp
          src/bun.js/bindings/webcrypto/CryptoAlgorithmEd25519.cpp
          src/bun.js/bindings/webcrypto/CryptoKeyOKPOpenSSL.cpp
        ]
      end
      files.each { |f| inreplace f, "#include <#{header}>", guard }
    end
    # CryptoAlgorithmHKDFOpenSSL.cpp includes BoringSSL-only openssl/hkdf.h.
    # On OpenSSL 3, HKDF is available through EVP_KDF in openssl/kdf.h.
    inreplace "src/bun.js/bindings/webcrypto/CryptoAlgorithmHKDFOpenSSL.cpp",
              "#include <openssl/hkdf.h>",
              <<~CPP.chomp
                #ifdef OPENSSL_IS_BORINGSSL
                #include <openssl/hkdf.h>
                #else
                #include <openssl/kdf.h>
                #include <openssl/params.h>
                #endif
              CPP
    # macOS 26 SDK libc++ lazy_split_view.h has a hard access-specifier
    # error (__outer_iterator/__inner_iterator forward-declared private but
    # defined as public struct).  The include chain is v8-memory-span.h →
    # <ranges> → lazy_split_view.h.  Avoid <ranges> on Apple altogether;
    # the features it enables (range concepts, contiguous_iterator_tag) are
    # not essential for Bun's V8 shim layer.
    inreplace "vendor/nodejs/include/node/v8-memory-span.h",
              "#if __has_include(<ranges>)",
              "#if __has_include(<ranges>) && !defined(__APPLE__)"
    # BIO_mem_contents is BoringSSL-only.  Use BIO_get_mem_ptr for OpenSSL 3.
    inreplace "src/bun.js/bindings/webcore/SerializedScriptValue.cpp",
              '#include "ncrypto.h"',
              "#include \"ncrypto.h\"\n#include <openssl/buffer.h>"
    inreplace "src/bun.js/bindings/webcore/SerializedScriptValue.cpp",
              "BIO_mem_contents(bio, &pemData, reinterpret_cast<size_t*>(&pemSize));",
              "{ BUF_MEM* bptr = nullptr; BIO_get_mem_ptr(bio, &bptr); " \
              "pemData = reinterpret_cast<const uint8_t*>(bptr->data); " \
              "pemSize = bptr->length; }",
              global: true
    # OpenSSL 3 EVP_PKEY_get0_EC_KEY returns const EC_KEY*, BoringSSL
    # returns non-const.  Add const_cast for the three call sites.
    inreplace "src/bun.js/bindings/webcrypto/CryptoAlgorithmECDSAOpenSSL.cpp",
              "EC_KEY* ecKey = EVP_PKEY_get0_EC_KEY(key.platformKey());",
              "EC_KEY* ecKey = const_cast<EC_KEY*>(EVP_PKEY_get0_EC_KEY(key.platformKey()));",
              global: true
    # ExceptionOr<Vector<uint8_t>> needs explicit move from Vector.
    inreplace "src/bun.js/bindings/webcrypto/CryptoAlgorithmECDSAOpenSSL.cpp",
              "        return signature;\n    } else {",
              "        return WTF::move(signature);\n    } else {"
    # ED25519_sign / ED25519_verify are BoringSSL-only.  Use the EVP API
    # for OpenSSL 3: construct an EVP_PKEY from the raw key material and
    # then call EVP_DigestSign / EVP_DigestVerify.
    inreplace "src/bun.js/bindings/webcrypto/CryptoAlgorithmEd25519.cpp",
              "// -- BUN --\n" \
              "#ifdef OPENSSL_IS_BORINGSSL\n" \
              "#include <openssl/curve25519.h>\n" \
              "#endif",
              <<~CPP.chomp
                // -- BUN --
                #ifdef OPENSSL_IS_BORINGSSL
                #include <openssl/curve25519.h>
                #endif
                #include <openssl/evp.h>
              CPP
    inreplace "src/bun.js/bindings/webcrypto/CryptoAlgorithmEd25519.cpp",
              <<~ORIG.chomp,
                static ExceptionOr<Vector<uint8_t>> signEd25519(const Vector<uint8_t>& sk, size_t len, const Vector<uint8_t>& data)
                {
                    uint8_t newSignature[64];

                    ED25519_sign(newSignature, data.begin(), data.size(), sk.begin());
                    return Vector<uint8_t>(std::span { newSignature, 64 });
                }
              ORIG
              <<~REPL.chomp
                static ExceptionOr<Vector<uint8_t>> signEd25519(const Vector<uint8_t>& sk, size_t len, const Vector<uint8_t>& data)
                {
                #ifdef OPENSSL_IS_BORINGSSL
                    uint8_t newSignature[64];
                    ED25519_sign(newSignature, data.begin(), data.size(), sk.begin());
                    return Vector<uint8_t>(std::span { newSignature, 64 });
                #else
                    auto pkey = EVP_PKEY_new_raw_private_key(EVP_PKEY_ED25519, nullptr, sk.begin(), len);
                    if (!pkey)
                        return Exception { OperationError };
                    auto ctx = EVP_MD_CTX_new();
                    if (!ctx || EVP_DigestSignInit(ctx, nullptr, nullptr, nullptr, pkey) <= 0) {
                        EVP_MD_CTX_free(ctx);
                        EVP_PKEY_free(pkey);
                        return Exception { OperationError };
                    }
                    size_t sigLen = 64;
                    Vector<uint8_t> sig(sigLen);
                    if (EVP_DigestSign(ctx, sig.begin(), &sigLen, data.begin(), data.size()) <= 0) {
                        EVP_MD_CTX_free(ctx);
                        EVP_PKEY_free(pkey);
                        return Exception { OperationError };
                    }
                    EVP_MD_CTX_free(ctx);
                    EVP_PKEY_free(pkey);
                    sig.shrink(sigLen);
                    return sig;
                #endif
                }
              REPL
    inreplace "src/bun.js/bindings/webcrypto/CryptoAlgorithmEd25519.cpp",
              <<~ORIG.chomp,
                static ExceptionOr<bool> verifyEd25519(const Vector<uint8_t>& key, size_t keyLengthInBytes, const Vector<uint8_t>& signature, const Vector<uint8_t> data)
                {
                    if (signature.size() != keyLengthInBytes * 2)
                        return false;

                    return ED25519_verify(data.begin(), data.size(), signature.begin(), key.begin()) == 1;
                }
              ORIG
              <<~REPL.chomp
                static ExceptionOr<bool> verifyEd25519(const Vector<uint8_t>& key, size_t keyLengthInBytes, const Vector<uint8_t>& signature, const Vector<uint8_t> data)
                {
                    if (signature.size() != keyLengthInBytes * 2)
                        return false;

                #ifdef OPENSSL_IS_BORINGSSL
                    return ED25519_verify(data.begin(), data.size(), signature.begin(), key.begin()) == 1;
                #else
                    auto pkey = EVP_PKEY_new_raw_public_key(EVP_PKEY_ED25519, nullptr, key.begin(), keyLengthInBytes);
                    if (!pkey)
                        return Exception { OperationError };
                    auto ctx = EVP_MD_CTX_new();
                    if (!ctx || EVP_DigestVerifyInit(ctx, nullptr, nullptr, nullptr, pkey) <= 0) {
                        EVP_MD_CTX_free(ctx);
                        EVP_PKEY_free(pkey);
                        return Exception { OperationError };
                    }
                    int ret = EVP_DigestVerify(ctx, signature.begin(), signature.size(), data.begin(), data.size());
                    EVP_MD_CTX_free(ctx);
                    EVP_PKEY_free(pkey);
                    return ret == 1;
                #endif
                }
              REPL
    # HKDF() is BoringSSL-only.  Use EVP_KDF for OpenSSL 3.
    inreplace "src/bun.js/bindings/webcrypto/CryptoAlgorithmHKDFOpenSSL.cpp",
              "if (HKDF(output.begin(), output.size(), algorithm, " \
              "key.key().begin(), key.key().size(), " \
              "parameters.saltVector().begin(), parameters.saltVector().size(), " \
              "parameters.infoVector().begin(), parameters.infoVector().size()) <= 0)\n        " \
              "return Exception { OperationError };",
              <<~CPP.chomp
                #ifdef OPENSSL_IS_BORINGSSL
                    if (HKDF(output.begin(), output.size(), algorithm, key.key().begin(), key.key().size(), parameters.saltVector().begin(), parameters.saltVector().size(), parameters.infoVector().begin(), parameters.infoVector().size()) <= 0)
                        return Exception { OperationError };
                #else
                    {
                        EVP_KDF* kdf = EVP_KDF_fetch(nullptr, "HKDF", nullptr);
                        if (!kdf) return Exception { OperationError };
                        EVP_KDF_CTX* kctx = EVP_KDF_CTX_new(kdf);
                        EVP_KDF_free(kdf);
                        if (!kctx) return Exception { OperationError };
                        const char* mdName = EVP_MD_get0_name(algorithm);
                        OSSL_PARAM params[] = {
                            OSSL_PARAM_construct_utf8_string("digest", const_cast<char*>(mdName), 0),
                            OSSL_PARAM_construct_octet_string("key", const_cast<uint8_t*>(key.key().begin()), key.key().size()),
                            OSSL_PARAM_construct_octet_string("salt", const_cast<uint8_t*>(parameters.saltVector().begin()), parameters.saltVector().size()),
                            OSSL_PARAM_construct_octet_string("info", const_cast<uint8_t*>(parameters.infoVector().begin()), parameters.infoVector().size()),
                            OSSL_PARAM_END
                        };
                        int rc = EVP_KDF_derive(kctx, output.begin(), output.size(), params);
                        EVP_KDF_CTX_free(kctx);
                        if (rc <= 0) return Exception { OperationError };
                    }
                #endif
              CPP
    # ncrpyto_engine.cpp: fix std::string_view → WTF::StringView signatures
    # and .data() → .utf8().data() call sites for OpenSSL engine API.
    [
      ["const std::string_view name,", "const WTF::StringView name,"],
      ["const std::string_view key_name)", "const WTF::StringView key_name)"],
      ["ENGINE_by_id(name.data())", "ENGINE_by_id(name.utf8().data())"],
      ['"SO_PATH", name.data(), 0)', '"SO_PATH", name.utf8().data(), 0)'],
      ["key_name.data(), nullptr", "key_name.utf8().data(), nullptr"],
    ].each do |from, to|
      inreplace "src/bun.js/bindings/ncrpyto_engine.cpp", from, to
    end
    # ncrypto.cpp: fix WTF::StringView / OpenSSL 3 API mismatches
    # (return type wraps, cipher suites arg, callback type conversion)
    [
      ["return reinterpret_cast<const char*>(buf + 3);",
       "return WTF::StringView::fromLatin1(reinterpret_cast<const char*>(buf + 3));"],
      ["return reinterpret_cast<const char*>(buf + 5);",
       "return WTF::StringView::fromLatin1(reinterpret_cast<const char*>(buf + 5));"],
      ["return SSL_CTX_set_ciphersuites(ctx_.get(), ciphers.length());",
       "return SSL_CTX_set_ciphersuites(ctx_.get(), ciphersUtf8.data());"],
      ["free_type(fetched);\n    auto& cb = *(static_cast<CipherCallbackContext*>(arg));\n    cb(from);",
       "free_type(fetched);\n    auto& cb = *(static_cast<CipherCallbackContext*>(arg));\n    cb(WTF::StringView::fromLatin1(from));"],
    ].each do |from, to|
      inreplace "src/bun.js/bindings/ncrypto.cpp", from, to
    end
    # Several bun classes use WTF_DEPRECATED_MAKE_FAST_ALLOCATED but their
    # base classes use WTF_MAKE_TZONE_ALLOCATED.  WebKit requires derived
    # classes to match the base allocation scheme.
    {
      "BunGCOutputConstraint" => ["DOMGCOutputConstraint", "namespace WebCore {"],
      "ConsoleObject"         => ["ConsoleObject", "namespace Bun {"],
    }.each do |file_stem, (klass, ns_line)|
      inreplace "src/bun.js/bindings/#{file_stem}.h",
                "WTF_DEPRECATED_MAKE_FAST_ALLOCATED(#{klass});",
                "WTF_MAKE_TZONE_ALLOCATED(#{klass});"
      inreplace "src/bun.js/bindings/#{file_stem}.cpp",
                "#include \"#{file_stem}.h\"",
                "#include \"#{file_stem}.h\"\n#include <wtf/TZoneMallocInlines.h>"
      inreplace "src/bun.js/bindings/#{file_stem}.cpp",
                ns_line,
                "#{ns_line}\n\nWTF_MAKE_TZONE_ALLOCATED_IMPL(#{klass});"
    end

    # JSBuffer.cpp references JSUint8Array::s_info which is an explicit
    # template specialization defined in the JSC library.  Tell the compiler
    # the definition exists in another translation unit.
    inreplace "src/bun.js/bindings/JSBuffer.cpp",
              '#include "root.h"',
              <<~CPP.chomp
                #include "root.h"
                #pragma clang diagnostic ignored "-Wundefined-var-template"
              CPP

    # CryptoKeyRSAOpenSSL.cpp: OpenSSL 3 EVP_PKEY_get0_RSA returns const RSA*.
    inreplace "src/bun.js/bindings/webcrypto/CryptoKeyRSAOpenSSL.cpp",
              "static size_t getRSAModulusLength(RSA* rsa)",
              "static size_t getRSAModulusLength(const RSA* rsa)"
    inreplace "src/bun.js/bindings/webcrypto/CryptoKeyRSAOpenSSL.cpp",
              "    RSA* rsa = EVP_PKEY_get0_RSA(",
              "    const RSA* rsa = EVP_PKEY_get0_RSA(",
              global: true
    # CryptoDigest.cpp takes addresses of deprecated SHA functions (SHA1_Init,
    # SHA256_Init, etc.) as constexpr function pointers.  These are deprecated
    # in OpenSSL 3 and -Werror makes it fatal.  Suppress for this file.
    inreplace "src/bun.js/bindings/webcrypto/CryptoDigest.cpp",
              '#include "CryptoDigest.h"',
              <<~CPP.chomp
                #include "CryptoDigest.h"
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Wdeprecated-declarations"
              CPP
    inreplace "src/bun.js/bindings/EncodingTables.h",
              '#pragma clang diagnostic ignored "-Wcharacter-conversion"',
              <<~CPP.chomp
                #if __has_warning("-Wcharacter-conversion")
                #pragma clang diagnostic ignored "-Wcharacter-conversion"
                #elif __has_warning("-Wvector-conversion")
                #pragma clang diagnostic ignored "-Wvector-conversion"
                #endif
              CPP
    # CryptoKeyECOpenSSL.cpp: OpenSSL 3 compat — guard deprecated
    # EC_KEY_set_asn1_flag (already the default with EC_KEY_new_by_curve_name)
    # and fix const return types from EVP_PKEY_get0_EC_KEY.
    inreplace "src/bun.js/bindings/webcrypto/CryptoKeyECOpenSSL.cpp",
              /^(\s+)EC_KEY_set_asn1_flag\((.+?), OPENSSL_EC_NAMED_CURVE\);/,
              "#ifdef OPENSSL_IS_BORINGSSL\n\\1EC_KEY_set_asn1_flag(\\2, OPENSSL_EC_NAMED_CURVE);\n#endif"
    inreplace "src/bun.js/bindings/webcrypto/CryptoKeyECOpenSSL.cpp",
              "    auto ecKey = EVP_PKEY_get0_EC_KEY(pkey.get());",
              "    auto ecKey = const_cast<EC_KEY*>(EVP_PKEY_get0_EC_KEY(pkey.get()));"
    inreplace "src/bun.js/bindings/webcrypto/CryptoKeyECOpenSSL.cpp",
              "    EC_KEY* key = EVP_PKEY_get0_EC_KEY(platformKey());",
              "    const EC_KEY* key = EVP_PKEY_get0_EC_KEY(platformKey());",
              global: true
    # CryptoKeyOKPOpenSSL.cpp: BoringSSL defines ED25519_PUBLIC_KEY_LEN etc.
    # in curve25519.h; provide fallback definitions for OpenSSL 3.
    inreplace "src/bun.js/bindings/webcrypto/CryptoKeyOKPOpenSSL.cpp",
              "#include \"CommonCryptoDERUtilities.h\"",
              <<~CPP.chomp
                #include "CommonCryptoDERUtilities.h"
                #ifndef OPENSSL_IS_BORINGSSL
                #define ED25519_PUBLIC_KEY_LEN 32
                #define ED25519_PRIVATE_KEY_LEN 64
                #define X25519_PUBLIC_VALUE_LEN 32
                #define X25519_PRIVATE_KEY_LEN 32
                #endif
              CPP
    # CryptoKeyOKPOpenSSL.cpp: ED25519_keypair, ED25519_keypair_from_seed,
    # X25519_keypair, X25519_public_from_private are BoringSSL-only.
    # Provide OpenSSL 3 EVP equivalents.
    inreplace "src/bun.js/bindings/webcrypto/CryptoKeyOKPOpenSSL.cpp",
              "namespace WebCore {",
              <<~CPP.chomp
                namespace WebCore {

                #ifndef OPENSSL_IS_BORINGSSL
                #include <openssl/evp.h>
                #include <openssl/rand.h>
                static void ED25519_keypair(uint8_t out_public_key[32], uint8_t out_private_key[64])
                {
                    EVP_PKEY* pkey = nullptr;
                    EVP_PKEY_CTX* ctx = EVP_PKEY_CTX_new_id(EVP_PKEY_ED25519, nullptr);
                    EVP_PKEY_keygen_init(ctx);
                    EVP_PKEY_keygen(ctx, &pkey);
                    EVP_PKEY_CTX_free(ctx);
                    size_t len = 32;
                    EVP_PKEY_get_raw_public_key(pkey, out_public_key, &len);
                    len = 64;
                    EVP_PKEY_get_raw_private_key(pkey, out_private_key, &len);
                    // OpenSSL returns 32-byte seed, but BoringSSL returns 64-byte (seed+pubkey)
                    // Bun code expects 64-byte private key (seed || public_key)
                    if (len == 32) {
                        memcpy(out_private_key + 32, out_public_key, 32);
                    }
                    EVP_PKEY_free(pkey);
                }
                static void X25519_keypair(uint8_t out_public_key[32], uint8_t out_private_key[32])
                {
                    EVP_PKEY* pkey = nullptr;
                    EVP_PKEY_CTX* ctx = EVP_PKEY_CTX_new_id(EVP_PKEY_X25519, nullptr);
                    EVP_PKEY_keygen_init(ctx);
                    EVP_PKEY_keygen(ctx, &pkey);
                    EVP_PKEY_CTX_free(ctx);
                    size_t len = 32;
                    EVP_PKEY_get_raw_public_key(pkey, out_public_key, &len);
                    len = 32;
                    EVP_PKEY_get_raw_private_key(pkey, out_private_key, &len);
                    EVP_PKEY_free(pkey);
                }
                static void ED25519_keypair_from_seed(uint8_t out_public_key[32], uint8_t out_private_key[64], const uint8_t seed[32])
                {
                    EVP_PKEY* pkey = EVP_PKEY_new_raw_private_key(EVP_PKEY_ED25519, nullptr, seed, 32);
                    size_t len = 32;
                    EVP_PKEY_get_raw_public_key(pkey, out_public_key, &len);
                    memcpy(out_private_key, seed, 32);
                    memcpy(out_private_key + 32, out_public_key, 32);
                    EVP_PKEY_free(pkey);
                }
                static void X25519_public_from_private(uint8_t out_public_key[32], const uint8_t private_key[32])
                {
                    EVP_PKEY* pkey = EVP_PKEY_new_raw_private_key(EVP_PKEY_X25519, nullptr, private_key, 32);
                    size_t len = 32;
                    EVP_PKEY_get_raw_public_key(pkey, out_public_key, &len);
                    EVP_PKEY_free(pkey);
                }
                #endif
              CPP

    # When using system libraries, the Build*.cmake files create IMPORTED targets
    # but return() before register_cmake_command which normally links artifacts to
    # the bun target. We must explicitly link them. Also add macOS frameworks
    # required by static libWTF.a and Security framework for SecTask*.
    sys_link_targets = %w[cares hdrhistogram libarchive zlib zstd libdeflate highway]
    conditional_links = sys_link_targets.map do |t|
      "if(TARGET #{t})\n  target_link_libraries(${bun} PRIVATE #{t})\nendif()"
    end.join("\n")
    inreplace "cmake/targets/BuildBun.cmake",
              "target_link_libraries(${bun} PRIVATE icucore resolv)",
              <<~CMAKE.chomp
                target_link_libraries(${bun} PRIVATE icucore resolv)
                target_link_libraries(${bun} PRIVATE "-framework CoreFoundation" "-framework Foundation" "-framework Security" objc)
                #{conditional_links}
                if(EXISTS ${WEBKIT_LIB_PATH}/libpas.a)
                  target_link_libraries(${bun} PRIVATE ${WEBKIT_LIB_PATH}/libpas.a)
                endif()
              CMAKE
    if OS.linux?
      # Full LTO frequently exhausts memory while linking `bun-profile` in
      # Linux CI; use ThinLTO to reduce linker RSS and force split LTO units.
      compiler_flags_file = "cmake/CompilerFlags.cmake"
      compiler_flags_before = File.read(compiler_flags_file)
      lto_flag_pattern = /-flto(?:=full)?(?= \$\{UNIX\}|$)/
      lto_split_flags = "-flto=thin -fsplit-lto-unit"
      lto_present = compiler_flags_before.match?(lto_flag_pattern) || compiler_flags_before.include?("-flto=thin")
      raise "Failed to lower Linux LTO mode in CompilerFlags.cmake" unless lto_present

      inreplace compiler_flags_file do |s|
        s.gsub!(lto_flag_pattern, "-flto=thin")
        s.gsub!(/-flto=thin(?! -fsplit-lto-unit)(?= \$\{UNIX\}|$)/, lto_split_flags)
      end

      compiler_flags_after = File.read(compiler_flags_file)
      raise "Failed to lower Linux LTO mode in CompilerFlags.cmake" unless compiler_flags_after.include?("-flto=thin")

      split_lto_enabled = compiler_flags_after.include?(lto_split_flags)
      raise "Failed to enable split Linux LTO mode in CompilerFlags.cmake" unless split_lto_enabled

      # Avoid ld.lld failures caused by LTO-generated `.lto_discard` entries
      # with versioned glibc symbols like exp@GLIBC_2.17.
      inreplace "cmake/targets/BuildBun.cmake",
                "  endif()\n\n  if(NOT ABI STREQUAL \"musl\")",
                <<~CMAKE.chomp
                  endif()

                  if(ENABLE_LTO)
                    set_source_files_properties(${CWD}/src/bun.js/bindings/workaround-missing-symbols.cpp
                      PROPERTIES COMPILE_OPTIONS "-fno-lto")
                  endif()

                  if(NOT ABI STREQUAL "musl")
                CMAKE
    end

    # Homebrew mimalloc installs flat headers (no mimalloc/ subdirectory) and
    # does not expose internal types.h. Only MI_MAX_ALIGN_SIZE is needed.
    inreplace "src/bun.js/bindings/MimallocWTFMalloc.h",
              '#include "mimalloc/types.h"',
              <<~CPP.chomp
                #ifndef MI_MAX_ALIGN_SIZE
                #define MI_MAX_ALIGN_SIZE 16
                #endif
              CPP

    # Xcode 16.4 libc++ no longer declares std::__libcpp_verbose_abort as
    # noexcept, so Bun's compatibility override must match that declaration.
    if OS.mac? && MacOS.version >= :sequoia
      inreplace "src/bun.js/bindings/workaround-missing-symbols.cpp",
                /void std::__libcpp_verbose_abort\((?:char const\*|const char\*) format, \.\.\.\) noexcept/,
                "void std::__libcpp_verbose_abort(char const* format, ...)"
    end

    # Create BoringSSL → OpenSSL 3 compatibility shim for pre-compiled bun-zig.o
    # which references BoringSSL-specific symbols not present in OpenSSL 3.
    # Also provides WTFTimer__fire which bridges Zig → C++ WTF::RunLoop::TimerBase.
    (buildpath/"src/bun.js/bindings/openssl3_compat_shim.cpp").write <<~CPP
      #include <openssl/ssl.h>
      #include <openssl/evp.h>
      #include <openssl/hmac.h>
      #include <openssl/bio.h>
      #include <openssl/crypto.h>
      #include <openssl/stack.h>
      #include <cstdint>
      #include <cstddef>
      #include <cstring>

      // WTF::RunLoop::TimerBase::fired() bridge for Zig
      namespace WTF { class RunLoop { public: class TimerBase {
      public: virtual void fired() = 0; virtual ~TimerBase() = default; }; }; }

      extern "C" {

      // --- WTFTimer bridge ---
      __attribute__((weak, visibility("default"))) void WTFTimer__fire(void* timer) {
          reinterpret_cast<WTF::RunLoop::TimerBase*>(timer)->fired();
      }

      // --- Deprecated OpenSSL functions that are macros in OpenSSL 3 ---
      // bun-zig.o calls these as functions, but OpenSSL 3 defines them as macros

      int EVP_MD_CTX_cleanup(EVP_MD_CTX* ctx) { return EVP_MD_CTX_reset(ctx); }

      // EVP_MD_CTX_init is already a macro in this OpenSSL but bun-zig.o needs the symbol
      #undef EVP_MD_CTX_init
      void EVP_MD_CTX_init(EVP_MD_CTX* ctx) { EVP_MD_CTX_reset(ctx); }

      #undef EVP_MD_CTX_size
      int EVP_MD_CTX_size(const EVP_MD_CTX* ctx) { return EVP_MD_CTX_get_size(ctx); }

      #undef EVP_PKEY_bits
      int EVP_PKEY_bits(const EVP_PKEY* pkey) { return EVP_PKEY_get_bits(pkey); }

      #undef EVP_PKEY_id
      int EVP_PKEY_id(const EVP_PKEY* pkey) { return EVP_PKEY_get_id(pkey); }

      void HMAC_CTX_init(HMAC_CTX* ctx) { (void)ctx; /* no-op, OpenSSL 3 uses HMAC_CTX_new */ }
      void HMAC_CTX_cleanup(HMAC_CTX* ctx) { (void)ctx; /* no-op, OpenSSL 3 uses HMAC_CTX_free */ }

      #undef SSL_get_peer_certificate
      X509* SSL_get_peer_certificate(const SSL* s) { return SSL_get1_peer_certificate(s); }

      #undef SSL_library_init
      int SSL_library_init(void) { return 1; /* no-op in OpenSSL 3 */ }
      #undef SSL_load_error_strings
      void SSL_load_error_strings(void) { /* no-op in OpenSSL 3 */ }
      #undef OpenSSL_add_all_algorithms
      void OpenSSL_add_all_algorithms(void) { /* no-op in OpenSSL 3 */ }
      void CRYPTO_library_init(void) { /* no-op - BoringSSL specific */ }

      // Mimalloc 3.x no longer exports mi_heap_get_default; map Bun's
      // expected symbol to the current public entry point.
      struct mi_heap_s;
      mi_heap_s* mi_heap_main(void);
      __attribute__((weak, visibility("default"))) mi_heap_s* mi_heap_get_default(void) {
          return mi_heap_main();
      }

      // --- sk_* functions (BoringSSL uses short names, OpenSSL 3 uses OPENSSL_sk_*) ---
      #undef sk_num
      size_t sk_num(const OPENSSL_STACK* sk) { return (size_t)OPENSSL_sk_num(sk); }
      #undef sk_value
      void* sk_value(const OPENSSL_STACK* sk, size_t i) {
          return OPENSSL_sk_value(sk, (int)i);
      }
      #undef sk_free
      void sk_free(OPENSSL_STACK* sk) { OPENSSL_sk_free(sk); }

      // BoringSSL sk_pop_free_ex takes a thunk; call thunk(free_func, elem) per element
      typedef void (*boringssl_sk_free_func)(void*);
      typedef void (*boringssl_sk_call_free_func)(boringssl_sk_free_func, void*);
      void sk_pop_free_ex(OPENSSL_STACK* sk,
                          boringssl_sk_call_free_func call_free_func,
                          boringssl_sk_free_func free_func) {
          if (!sk) return;
          int n = OPENSSL_sk_num(sk);
          for (int i = 0; i < n; i++) {
              void* elem = OPENSSL_sk_value(sk, i);
              if (elem && call_free_func && free_func)
                  call_free_func(free_func, elem);
          }
          OPENSSL_sk_free(sk);
      }

      // --- SSL macros that bun-zig.o calls as functions ---
      #undef SSL_set_tlsext_host_name
      long SSL_set_tlsext_host_name(SSL* s, const char* name) {
          return SSL_ctrl(s, SSL_CTRL_SET_TLSEXT_HOSTNAME,
                          TLSEXT_NAMETYPE_host_name, (void*)name);
      }

      #undef SSL_set_max_send_fragment
      long SSL_set_max_send_fragment(SSL* ssl, long m) {
          return SSL_ctrl(ssl, SSL_CTRL_SET_MAX_SEND_FRAGMENT, m, NULL);
      }

      #undef BIO_set_mem_eof_return
      long BIO_set_mem_eof_return(BIO* b, int v) {
          return BIO_ctrl(b, BIO_C_SET_BUF_MEM_EOF_RETURN, v, NULL);
      }

      // --- BoringSSL-only stubs ---
      void* CRYPTO_BUFFER_POOL_new(void) { return NULL; }
      void SSL_CTX_set0_buffer_pool(SSL_CTX* ctx, void* pool) {
          (void)ctx; (void)pool;
      }
      int SSL_enable_ocsp_stapling(SSL* ssl) { (void)ssl; return 1; }
      int SSL_enable_signed_cert_timestamps(SSL* ssl) { (void)ssl; return 1; }
      int SSL_set_enable_ech_grease(SSL* ssl, int en) { (void)ssl; (void)en; return 1; }
      void SSL_set_renegotiate_mode(SSL* ssl, int m) { (void)ssl; (void)m; }

      int EVP_PBE_validate_scrypt_params(uint64_t N, uint64_t r, uint64_t p,
                                          uint64_t maxmem) {
          if (N < 2 || (N & (N - 1)) != 0) return 0;
          if (r == 0 || p == 0) return 0;
          (void)maxmem;
          return 1;
      }

      const EVP_MD* EVP_blake2b256(void) {
          return EVP_MD_fetch(NULL, "BLAKE2B-256", NULL);
      }

      unsigned char* SHA512_256(const unsigned char* data, size_t len,
                                unsigned char* out) {
          EVP_MD_CTX* ctx = EVP_MD_CTX_new();
          if (!ctx) return NULL;
          const EVP_MD* md = EVP_MD_fetch(NULL, "SHA512-256", NULL);
          if (!md) { EVP_MD_CTX_free(ctx); return NULL; }
          unsigned int md_len = 0;
          if (EVP_DigestInit_ex(ctx, md, NULL) &&
              EVP_DigestUpdate(ctx, data, len) &&
              EVP_DigestFinal_ex(ctx, out, &md_len)) {
              EVP_MD_free((EVP_MD*)md);
              EVP_MD_CTX_free(ctx);
              return out;
          }
          EVP_MD_free((EVP_MD*)md);
          EVP_MD_CTX_free(ctx);
          return NULL;
      }

      } // extern "C"
    CPP

    # Add shim and stub sources to the build source list
    inreplace "cmake/targets/BuildBun.cmake",
              "list(APPEND BUN_CPP_SOURCES",
              <<~CMAKE.chomp
                list(APPEND BUN_CXX_SOURCES ${CWD}/src/bun.js/bindings/openssl3_compat_shim.cpp)
                list(APPEND BUN_CXX_SOURCES ${CWD}/src/bun.js/bindings/missing_webkit_stubs.cpp)
                list(APPEND BUN_CPP_SOURCES
              CMAKE

    # Add WTF_MAKE_TZONE_ALLOCATED_IMPL for classes that declare WTF_MAKE_TZONE_ALLOCATED
    # in their headers but lack the corresponding IMPL in any .cpp file.
    # Needed because our WebKit is built with USE(TZONE_MALLOC) which generates
    # s_heapRef and operatorNewSlow declarations that need definitions.
    tzone_impl = "\n#include <wtf/TZoneMallocInlines.h>\n"

    # Bun:: namespace classes
    {
      "src/bun.js/bindings/node/crypto/CryptoHkdf.cpp"          => %w[HkdfJobCtx],
      "src/bun.js/bindings/node/crypto/CryptoSignJob.cpp"       => %w[SignJobCtx],
      "src/bun.js/bindings/node/crypto/CryptoGenDhKeyPair.cpp"  => %w[DhKeyPairJobCtx],
      "src/bun.js/bindings/node/crypto/CryptoGenEcKeyPair.cpp"  => %w[EcKeyPairJobCtx],
      "src/bun.js/bindings/node/crypto/CryptoKeygen.cpp"        => %w[SecretKeyJobCtx],
      "src/bun.js/bindings/node/crypto/CryptoGenDsaKeyPair.cpp" => %w[DsaKeyPairJobCtx],
      "src/bun.js/bindings/node/crypto/CryptoGenNidKeyPair.cpp" => %w[NidKeyPairJobCtx],
      "src/bun.js/bindings/node/crypto/CryptoGenRsaKeyPair.cpp" => %w[RsaKeyPairJobCtx],
      "src/bun.js/bindings/node/crypto/CryptoDhJob.cpp"         => %w[DhJobCtx],
      "src/bun.js/bindings/node/crypto/CryptoPrimes.cpp"        => %w[CheckPrimeJobCtx GeneratePrimeJobCtx],
      "src/bun.js/bindings/EventLoopTaskNoContext.cpp"          => %w[EventLoopTaskNoContext],
      "src/bun.js/bindings/Weak.cpp"                            => %w[WeakRef],
      "src/bun.js/bindings/JSCTaskScheduler.cpp"                => %w[JSCDeferredWorkTask],
    }.each do |file, classes|
      File.open(buildpath/file, "a") do |f|
        f.puts tzone_impl
        f.puts "namespace Bun {"
        classes.each { |cls| f.puts "WTF_MAKE_TZONE_ALLOCATED_IMPL(#{cls});" }
        f.puts "}"
      end
    end

    # WebCore:: namespace classes
    {
      "src/bun.js/bindings/ScriptExecutionContext.cpp"          => %w[ScriptExecutionContext EventLoopTask],
      "src/bun.js/bindings/webcrypto/CryptoAlgorithmX25519.cpp" => %w[CryptoAlgorithmX25519Params],
      "src/bun.js/bindings/webcore/URLPattern.cpp"              => %w[URLPattern],
    }.each do |file, classes|
      File.open(buildpath/file, "a") do |f|
        f.puts tzone_impl
        f.puts "namespace WebCore {"
        classes.each { |cls| f.puts "WTF_MAKE_TZONE_ALLOCATED_IMPL(#{cls});" }
        f.puts "}"
      end
    end

    # Global namespace classes
    File.open(buildpath/"src/bun.js/bindings/node/crypto/KeyObject.cpp", "a") do |f|
      f.puts tzone_impl
      f.puts "WTF_MAKE_TZONE_ALLOCATED_IMPL(KeyObjectData);"
    end

    # Struct variants (WTF_MAKE_STRUCT_TZONE_ALLOCATED_IMPL)
    {
      "src/bun.js/bindings/JSSecrets.cpp" => ["Bun", "SecretsJobOptions"],
      "src/bun.js/bindings/napi.cpp"      => [nil, "NapiEnv"],
    }.each do |file, (ns, cls)|
      File.open(buildpath/file, "a") do |f|
        f.puts tzone_impl
        f.puts "namespace #{ns} {" if ns
        f.puts "WTF_MAKE_STRUCT_TZONE_ALLOCATED_IMPL(#{cls});"
        f.puts "}" if ns
      end
    end

    # Stub bmalloc::memoryStatus() and Inspector::RemoteInspectorServer
    # which are not present in our WebKit build.
    # Functions must be out-of-line with default visibility to be exported,
    # since the build uses -fvisibility=hidden.
    (buildpath/"src/bun.js/bindings/missing_webkit_stubs.cpp").write <<~CPP
      #include <cstddef>

      namespace bmalloc {
      struct MemoryStatus {
          MemoryStatus(size_t mf, double pam) : memoryFootprint(mf), percentAvailableMemoryInUse(pam) {}
          size_t memoryFootprint;
          double percentAvailableMemoryInUse;
      };
      __attribute__((weak, visibility("default"))) MemoryStatus memoryStatus() { return MemoryStatus(0, 0.5); }
      } // namespace bmalloc

      namespace Inspector {
      class RemoteInspectorServer {
      public:
          static RemoteInspectorServer& singleton();
          bool start(const char*, unsigned short);
      };
      __attribute__((weak, visibility("default"))) RemoteInspectorServer& RemoteInspectorServer::singleton() {
          static RemoteInspectorServer instance;
          return instance;
      }
      __attribute__((weak, visibility("default"))) bool RemoteInspectorServer::start(const char*, unsigned short) {
          return false;
      }
      } // namespace Inspector
    CPP

    # macOS strip doesn't support GNU-style flags; replace with macOS equivalents
    inreplace "cmake/targets/BuildBun.cmake",
              "set(CMAKE_STRIP_FLAGS --remove-section=__TEXT,__eh_frame " \
              "--remove-section=__TEXT,__unwind_info --remove-section=__TEXT,__gcc_except_tab)",
              'set(CMAKE_STRIP_FLAGS "")'
    # Replace GNU --strip-all/--strip-debug/--discard-all with macOS -x
    inreplace "cmake/targets/BuildBun.cmake",
              "          --strip-all\n          --strip-debug\n          --discard-all\n",
              "          -x\n"

    system "cmake", "--build", "build", *build_args

    # Bun has no cmake install() rules; install the stripped binary manually
    bin.install "build/bun"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bun --version")
    (testpath/"hello.js").write("console.log('ok')")
    assert_match "ok", shell_output("#{bin}/bun run #{testpath}/hello.js")
    # Verify the transpiler works (a core bun feature beyond simple script execution)
    (testpath/"ts_test.ts").write("const x: number = 42; console.log(x);")
    assert_match "42", shell_output("#{bin}/bun run #{testpath}/ts_test.ts")
  end
end

__END__
From d3cb93d12d119e2f18d15529821c02c6507efd5f Mon Sep 17 00:00:00 2001
From: Rui Chen <rui@chenrui.dev>
Date: Fri, 6 Feb 2026 13:09:40 -0500
Subject: [PATCH 1/4] cmake: add bun bootstrap toggle

---
 cmake/targets/BuildBun.cmake |  9 +++++++++
 cmake/tools/SetupBun.cmake   | 13 +++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/cmake/targets/BuildBun.cmake b/cmake/targets/BuildBun.cmake
index 64536cc26b..05493136a6 100644
--- a/cmake/targets/BuildBun.cmake
+++ b/cmake/targets/BuildBun.cmake
@@ -434,5 +434,9 @@ string(REPLACE ";" "," BUN_BINDGENV2_SOURCES_COMMA_SEPARATED
   "${BUN_BINDGENV2_SOURCES}")
 
+if (BUN_BOOTSTRAP STREQUAL "OFF" OR BUN_EXECUTABLE STREQUAL "BUN_BOOTSTRAP_DISABLED")
+  message(STATUS "BUN_BOOTSTRAP=OFF: bindgen-v2 codegen requires pre-generated outputs.")
+endif()
+
 execute_process(
   COMMAND ${BUN_EXECUTABLE} ${BUN_FLAGS} run ${BUN_BINDGENV2_SCRIPT}
     --command=list-outputs
@@ -1583,3 +1583,6 @@ if(NOT BUN_CPP_ONLY)
     endif()
   endif()
 endif()
+if (BUN_BOOTSTRAP STREQUAL "OFF" OR BUN_EXECUTABLE STREQUAL "BUN_BOOTSTRAP_DISABLED")
+  message(STATUS "BUN_BOOTSTRAP=OFF: codegen targets require pre-generated outputs.")
+endif()
diff --git a/cmake/tools/SetupBun.cmake b/cmake/tools/SetupBun.cmake
index b57d29b9a1..c598b96798 100644
--- a/cmake/tools/SetupBun.cmake
+++ b/cmake/tools/SetupBun.cmake
@@ -1,3 +1,16 @@
+option(BUN_BOOTSTRAP "Require Bun to build" ON)
+
+if (NOT BUN_BOOTSTRAP)
+  message(STATUS "BUN_BOOTSTRAP=OFF: skipping bun requirement. Codegen must be pre-generated.")
+  set(BUN_EXECUTABLE "true")
+  return()
+endif()
+
+if (BUN_EXECUTABLE AND EXISTS ${BUN_EXECUTABLE})
+  message(STATUS "Using provided Bun executable: ${BUN_EXECUTABLE}")
+  return()
+endif()
+
 find_command(
   VARIABLE
     BUN_EXECUTABLE
-- 
2.50.1 (Apple Git-155)


From 160702c711148884bfca484e24fad868c800d57a Mon Sep 17 00:00:00 2001
From: Rui Chen <rui@chenrui.dev>
Date: Fri, 6 Feb 2026 13:09:40 -0500
Subject: [PATCH 2/4] cmake: add system dep toggles

---
 cmake/targets/BuildLibuv.cmake  | 9 +++++++++
 cmake/targets/BuildSQLite.cmake | 9 +++++++++
 2 files changed, 18 insertions(+)

diff --git a/cmake/targets/BuildLibuv.cmake b/cmake/targets/BuildLibuv.cmake
index 3072d95532..6108c42711 100644
--- a/cmake/targets/BuildLibuv.cmake
+++ b/cmake/targets/BuildLibuv.cmake
@@ -1,3 +1,12 @@
+option(USE_SYSTEM_LIBUV "Use system libuv" OFF)
+
+if (USE_SYSTEM_LIBUV)
+  find_package(PkgConfig REQUIRED)
+  pkg_check_modules(LIBUV REQUIRED libuv)
+  message(STATUS "Using system libuv")
+  return()
+endif()
+
 register_repository(
   NAME
     libuv
diff --git a/cmake/targets/BuildSQLite.cmake b/cmake/targets/BuildSQLite.cmake
index ce4cd8da24..a848320388 100644
--- a/cmake/targets/BuildSQLite.cmake
+++ b/cmake/targets/BuildSQLite.cmake
@@ -1,3 +1,12 @@
+option(USE_SYSTEM_SQLITE "Use system SQLite" OFF)
+
+if (USE_SYSTEM_SQLITE)
+  find_package(PkgConfig REQUIRED)
+  pkg_check_modules(SQLITE3 REQUIRED sqlite3)
+  message(STATUS "Using system SQLite")
+  return()
+endif()
+
 register_cmake_command(
   TARGET
     sqlite
-- 
2.50.1 (Apple Git-155)


From 850663497e8884c4972a570efae2b73f3b4e27a9 Mon Sep 17 00:00:00 2001
From: Rui Chen <rui@chenrui.dev>
Date: Fri, 6 Feb 2026 13:12:33 -0500
Subject: [PATCH 3/4] cmake: allow register_command target dependency

---
 cmake/Globals.cmake | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/cmake/Globals.cmake b/cmake/Globals.cmake
index ab78654512..ae6cfdf827 100644
--- a/cmake/Globals.cmake
+++ b/cmake/Globals.cmake
@@ -428,6 +428,10 @@ function(register_command)
   set(CMD_COMMANDS COMMAND ${CMD_COMMAND})
   set(CMD_EFFECTIVE_DEPENDS)
 
+  if(CMD_TARGET)
+    list(APPEND CMD_EFFECTIVE_DEPENDS ${CMD_TARGET})
+  endif()
+
   list(GET CMD_COMMAND 0 CMD_EXECUTABLE)
  if(CMD_EXECUTABLE MATCHES "/|\\\\")
    list(APPEND CMD_EFFECTIVE_DEPENDS ${CMD_EXECUTABLE})
-- 
2.50.1 (Apple Git-155)

--- a/cmake/tools/SetupWebKit.cmake
+++ b/cmake/tools/SetupWebKit.cmake
@@ -25,6 +25,18 @@
 
 set(WEBKIT_INCLUDE_PATH ${WEBKIT_PATH}/include)
 set(WEBKIT_LIB_PATH ${WEBKIT_PATH}/lib)
+if(WEBKIT_LOCAL)
+  if(NOT EXISTS ${WEBKIT_INCLUDE_PATH} AND EXISTS ${WEBKIT_PATH}/usr/local/include)
+    set(WEBKIT_INCLUDE_PATH ${WEBKIT_PATH}/usr/local/include)
+  endif()
+  if(NOT EXISTS ${WEBKIT_LIB_PATH})
+    if(EXISTS ${WEBKIT_PATH}/libJavaScriptCore.a)
+      set(WEBKIT_LIB_PATH ${WEBKIT_PATH})
+    elseif(EXISTS ${WEBKIT_PATH}/usr/local/lib)
+      set(WEBKIT_LIB_PATH ${WEBKIT_PATH}/usr/local/lib)
+    endif()
+  endif()
+endif()
 
 if(WEBKIT_LOCAL)
   if(EXISTS ${WEBKIT_PATH}/cmakeconfig.h)
