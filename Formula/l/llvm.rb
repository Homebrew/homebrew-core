class Llvm < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 2
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-23.1.0/llvm-project-23.1.0.src.tar.xz"
    sha256 "ab1f0e3ec52448c33e8782eaf0422504b87c7b016b22514653ee0d8fcee479ff"

    # Fix triple config loading for clang-cl
    patch do
      url "https://github.com/llvm/llvm-project/compare/1381ad497b9a6d3da630cbef53cbfa9ddf117bb6...40a8c7c0ff3f688b690e4c74db734de67f0f89e9.diff"
      sha256 "f6dafd762737eb79761ab7ef814a9fc802ec4bb8d20f46691f07178053b0eb36"
      type :unofficial
      resolves "https://github.com/llvm/llvm-project/pull/111397"
    end
  end

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "a916d9bdae80f1ea47374528e43f5b1b5f864f3fc9c9ae6db02faa5cba6b3f25"
    sha256               arm64_sequoia: "ccaf29d02d4dffa52584e5720c711accac378664f1098ef1232defa5d4eb53e0"
    sha256               arm64_sonoma:  "93d3fc19acc5605054408ab47caed44e4d36729cc1cd5a29a524b9d8a312d5e3"
    sha256 cellar: :any, sonoma:        "0b0168dc611a9d77aaa62d094178297f8a861d647cc59c43a5dc3f76bd6eb7b2"
    sha256 cellar: :any, arm64_linux:   "1a2ddcf091e4d316f302ba561f5bf3741cd23e8f309ccb53df9b721c944145a3"
    sha256 cellar: :any, x86_64_linux:  "654dd1c77fe25f5daca8e46de9c8e26da97ad30bcb6d3f13a00e74d36932b215"
  end

  keg_only :provided_by_macos

  # https://llvm.org/docs/GettingStarted.html#requirement
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "zstd"

  uses_from_macos "libedit"
  uses_from_macos "libffi"

  # Z3 needs C++20 std::format which is only available in Xcode 15.3 or later.
  # To avoid a dependency loop, we disable Z3 support on older macOS.
  on_system :linux, macos: :sonoma_or_newer do
    depends_on "z3"
  end

  on_linux do
    depends_on "binutils" => :build # needed for LLVMgold plugin
    depends_on "pkgconf" => :build
    depends_on "zlib-ng-compat"
  end

  def python3 = "python3.14"

  def clang_config_file_dir = etc/"clang"

  def install
    # The clang bindings need a little help finding keg-only libclang.
    inreplace "clang/bindings/python/clang/cindex.py",
              "= os.environ.get(\"LIBCLANG_LIBRARY_PATH\")",
              "= os.environ.get(\"LIBCLANG_LIBRARY_PATH\", \"#{lib}\")"

    projects = %w[
      clang
      clang-tools-extra
      mlir
      polly
    ]
    runtimes = %w[
      compiler-rt
      libcxx
      libcxxabi
      libunwind
      openmp
    ]

    unless versioned_formula?
      odie "Remove Z3 solver!" if build.stable? && version >= "24"
      enable_z3 = deps.map(&:name).include?("z3")
    end

    python_versions = Formula.names
                             .select { |name| name.start_with? "python@" }
                             .map { |py| py.delete_prefix("python@") }

    # compiler-rt has some iOS simulator features that require i386 symbols
    # I'm assuming the rest of clang needs support too for 32-bit compilation
    # to work correctly, but if not, perhaps universal binaries could be
    # limited to compiler-rt. llvm makes this somewhat easier because compiler-rt
    # can almost be treated as an entirely different build from llvm.
    ENV.permit_arch_flags

    args = %W[
      -DLLVM_ENABLE_PROJECTS=#{projects.join(";")}
      -DLLVM_ENABLE_RUNTIMES=#{runtimes.join(";")}
      -DLLVM_POLLY_LINK_INTO_TOOLS=ON
      -DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON
      -DLLVM_LINK_LLVM_DYLIB=ON
      -DLLVM_ENABLE_EH=OFF
      -DLLVM_ENABLE_FFI=ON
      -DLLVM_ENABLE_RTTI=ON
      -DLLVM_ENABLE_Z3_SOLVER=#{enable_z3 ? "ON" : "OFF"}
      -DLLVM_INCLUDE_BENCHMARKS=OFF
      -DLLVM_INCLUDE_DOCS=OFF
      -DLLVM_INCLUDE_TESTS=OFF
      -DLLVM_INSTALL_UTILS=ON
      -DLLVM_OPTIMIZED_TABLEGEN=ON
      -DLLVM_TARGETS_TO_BUILD=all
      -DLLVM_USE_RELATIVE_PATHS_IN_FILES=ON
      -DLLVM_SOURCE_PREFIX=.
      -DLIBOMP_INSTALL_ALIASES=OFF
      -DLIBCXX_INSTALL_MODULES=ON
      -DCLANG_PYTHON_BINDINGS_VERSIONS=#{python_versions.join(";")}
      -DLLVM_CREATE_XCODE_TOOLCHAIN=OFF
      -DCLANG_FORCE_MATCHING_LIBCLANG_SOVERSION=OFF
      -DCLANG_CONFIG_FILE_SYSTEM_DIR=../etc/clang
      -DCLANG_CONFIG_FILE_USER_DIR=~/.config/clang
    ]

    if tap.present?
      args += %W[
        -DPACKAGE_VENDOR=#{tap.user}
        -DBUG_REPORT_URL=#{tap.issues_url}
      ]
      args << "-DCLANG_VENDOR_UTI=sh.brew.clang" if tap.official?
    end

    runtimes_cmake_args = []
    builtins_cmake_args = []

    if OS.mac?
      macos_sdk = MacOS.sdk_path
      args << "-DFFI_INCLUDE_DIR=#{macos_sdk}/usr/include/ffi"
      args << "-DFFI_LIBRARY_DIR=#{macos_sdk}/usr/lib"

      libcxx_install_libdir = lib/"c++"
      libunwind_install_libdir = lib/"unwind"
      libcxx_rpaths = [loader_path, rpath(source: libcxx_install_libdir, target: libunwind_install_libdir)]

      args << "-DLLVM_BUILD_LLVM_C_DYLIB=ON"
      args << "-DLLVM_ENABLE_LIBCXX=ON"
      args << "-DLIBCXX_ENABLE_VENDOR_AVAILABILITY_ANNOTATIONS=ON"
      args << "-DLIBCXX_PSTL_BACKEND=libdispatch"
      args << "-DLIBCXX_INSTALL_LIBRARY_DIR=#{libcxx_install_libdir}"
      args << "-DLIBUNWIND_INSTALL_LIBRARY_DIR=#{libunwind_install_libdir}"
      args << "-DLIBCXXABI_INSTALL_LIBRARY_DIR=#{libcxx_install_libdir}"
      runtimes_cmake_args << "-DCMAKE_INSTALL_RPATH=#{libcxx_rpaths.join("|")}"

      # Disable builds for OSes not supported by the CLT SDK.
      clt_sdk_support_flags = %w[I WATCH TV].map { |os| "-DCOMPILER_RT_ENABLE_#{os}OS=OFF" }
      builtins_cmake_args += clt_sdk_support_flags
    else
      args << "-DFFI_INCLUDE_DIR=#{formula_opt_include("libffi")}"
      args << "-DFFI_LIBRARY_DIR=#{formula_opt_lib("libffi")}"

      # Disable OMPD gdb plugin to avoid Python linkage
      args << "-DLIBOMP_OMPD_GDB_SUPPORT=OFF"
      # Disable `libxml2` which isn't very useful.
      args << "-DLLVM_ENABLE_LIBXML2=OFF"
      args << "-DLLVM_ENABLE_LIBCXX=OFF"
      args << "-DCLANG_DEFAULT_CXX_STDLIB=libstdc++"
      # Enable llvm gold plugin for LTO
      args << "-DLLVM_BINUTILS_INCDIR=#{formula_opt_include("binutils")}"
      # Parts of Polly fail to correctly build with PIC when being used for DSOs.
      args << "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
      runtimes_cmake_args += %w[
        -DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=OFF
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON

        -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON
        -DLIBCXX_STATICALLY_LINK_ABI_IN_SHARED_LIBRARY=OFF
        -DLIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY=ON
        -DLIBCXX_USE_COMPILER_RT=ON
        -DLIBCXX_HAS_ATOMIC_LIB=OFF

        -DLIBCXXABI_ENABLE_STATIC_UNWINDER=ON
        -DLIBCXXABI_STATICALLY_LINK_UNWINDER_IN_SHARED_LIBRARY=OFF
        -DLIBCXXABI_STATICALLY_LINK_UNWINDER_IN_STATIC_LIBRARY=ON
        -DLIBCXXABI_USE_COMPILER_RT=ON
        -DLIBCXXABI_USE_LLVM_UNWINDER=ON

        -DLIBUNWIND_USE_COMPILER_RT=ON
        -DCOMPILER_RT_USE_BUILTINS_LIBRARY=ON
        -DCOMPILER_RT_USE_LLVM_UNWINDER=ON

        -DSANITIZER_CXX_ABI=libc++
        -DSANITIZER_TEST_CXX=libc++
      ]

      # Prevent compiler-rt from building i386 targets, as this is not portable.
      builtins_cmake_args << "-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON"
    end

    # Skip the PGO build on HEAD installs, non-bottle source builds, or versioned formulae.
    pgo_build = build.stable? && build.bottle? && !versioned_formula?
    lto_build = pgo_build && OS.mac?

    llvmpath = buildpath/"llvm"
    if pgo_build
      # We build LLVM a few times first for optimisations. See
      # https://github.com/Homebrew/homebrew-core/issues/77975
      # PGO build adapted from:
      # https://llvm.org/docs/HowToBuildWithPGO.html#building-clang-with-pgo
      # https://github.com/llvm/llvm-project/blob/33ba8bd2/llvm/utils/collect_and_build_with_pgo.py
      # https://github.com/facebookincubator/BOLT/blob/01f471e7/docs/OptimizingClang.md
      stage1 = buildpath/"stage1"
      stage2 = buildpath/"stage2"
      stage2_profdata = buildpath/"stage2-profdata"

      # We build the basic parts of a toolchain to profile.
      # The extra targets on macOS are part of a default Compiler-RT build.
      extra_args = %W[
        -DLLVM_TARGETS_TO_BUILD=Native#{";AArch64;ARM;X86" if OS.mac?}
        -DLLVM_ENABLE_PROJECTS=clang;lld
        -DLLVM_ENABLE_RUNTIMES=compiler-rt
      ]
      if OS.mac?
        extra_args << "-DLLVM_ENABLE_LIBCXX=ON"
        extra_args += clt_sdk_support_flags
      else
        # Stage 2 and 3 happen outside the superenv so set up flags to match our cc shim
        ENV.append_to_cflags "-mbranch-protection=standard" if Hardware::CPU.arm64?
        ENV["HOMEBREW_INCLUDE_PATHS"].to_s.split(":").each { ENV.append_to_cflags "-I#{it}" }
        ENV["HOMEBREW_ISYSTEM_PATHS"].to_s.split(":").each { ENV.append_to_cflags "-isystem#{it}" }

        rpaths = ENV["HOMEBREW_RPATH_PATHS"].to_s.split(":")
        ldflags = ENV["HOMEBREW_LIBRARY_PATHS"].to_s.split(":").map { "-L#{it}" }
        ldflags << "-Wl,--dynamic-linker=#{ENV["HOMEBREW_DYNAMIC_LINKER"]}" if ENV["HOMEBREW_DYNAMIC_LINKER"].present?
        ldflags << "-B#{formula_opt_lib("glibc")}" if formula_opt_lib("glibc").directory?
        cmake_ldflags_args = %w[EXE MODULE SHARED].map { "-DCMAKE_#{it}_LINKER_FLAGS=#{ldflags.join(" ")}" }

        [args, extra_args, runtimes_cmake_args].each { it.concat(cmake_ldflags_args) }
        [args, extra_args].each { it << "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}" }
        runtimes_cmake_args << "-DCMAKE_INSTALL_RPATH=#{rpaths.join("|")}"
      end

      cflags = ENV.cflags&.split || []
      cxxflags = ENV.cxxflags&.split || []
      extra_args << "-DCMAKE_C_FLAGS=#{cflags.join(" ")}" unless cflags.empty?
      extra_args << "-DCMAKE_CXX_FLAGS=#{cxxflags.join(" ")}" unless cxxflags.empty?

      # Our stage1 compiler includes the minimum necessary to bootstrap.
      # `llvm-profdata` is needed for profile data pre-processing, and
      # `compiler-rt` to consume profile data.
      stage1_targets = ["clang", "llvm-profdata", "compiler-rt"]
      stage1_targets << "lld" if OS.linux? # We use lld on Linux to control RPATH
      if lto_build
        args << "-DLLVM_ENABLE_LTO=Thin"
        if OS.mac?
          # LTO creates object files not recognised by Apple libtool.
          args << "-DCMAKE_LIBTOOL=#{stage1}/bin/llvm-libtool-darwin"
          stage1_targets += ["llvm-libtool-darwin", "LTO"]
        else
          args << "-DLLVM_ENABLE_FATLTO=ON"
        end
      end

      # First, build a stage1 compiler. It might be possible to skip this step on macOS
      # and use system Clang instead, but this stage does not take too long, and we want
      # to avoid incompatibilities from generating profile data with a newer Clang than
      # the one we consume the data with.
      system "cmake", "-S", llvmpath, "-B", stage1, "-G", "Ninja", *extra_args, *std_cmake_args
      system "cmake", "--build", stage1, "--target", *stage1_targets

      # Barring the stage where we generate the profile data, there is no benefit to
      # rebuilding these.
      extra_args << "-DCLANG_TABLEGEN=#{stage1}/bin/clang-tblgen"
      extra_args << "-DLLVM_TABLEGEN=#{stage1}/bin/llvm-tblgen"
      # Use stage1 lld instead of ld shim so that we can control RPATH.
      [args, extra_args].each { it << "-DLLVM_USE_LINKER=lld" } if OS.linux?

      # LLVM Profile runs out of static counters
      # https://reviews.llvm.org/D92669, https://reviews.llvm.org/D93281
      # Without this, the build produces many warnings of the form
      # LLVM Profile Warning: Unable to track new values: Running out of static counters.
      instrumented_cflags = cflags + %w[-Xclang -mllvm -Xclang -vp-counters-per-site=6]
      instrumented_cxxflags = cxxflags + %w[-Xclang -mllvm -Xclang -vp-counters-per-site=6]
      instrumented_extra_args = extra_args.reject { |s| s[/CMAKE_C(XX)?_FLAGS/] }

      # Next, build an instrumented stage2 compiler
      system "cmake", "-S", llvmpath, "-B", stage2, "-G", "Ninja",
                      "-DCMAKE_C_COMPILER=#{stage1}/bin/clang",
                      "-DCMAKE_CXX_COMPILER=#{stage1}/bin/clang++",
                      "-DLLVM_BUILD_INSTRUMENTED=IR",
                      "-DLLVM_BUILD_RUNTIME=NO",
                      "-DCMAKE_C_FLAGS=#{instrumented_cflags.join(" ")}",
                      "-DCMAKE_CXX_FLAGS=#{instrumented_cxxflags.join(" ")}",
                      *instrumented_extra_args, *std_cmake_args
      system "cmake", "--build", stage2, "--target", "clang", "lld", "runtimes"
      # We run some `check-*` targets to increase profiling
      # coverage. These do not need to succeed.
      # NOTE: If using `Unix Makefiles` generator, `-k 0` needs to replaced with `--keep-going`.
      begin
        system "cmake", "--build", stage2, "--target", "check-clang", "check-llvm", "--", "-k", "0"
      rescue BuildError
        nil
      end

      # Then, generate the profile data
      system "cmake", "-S", llvmpath, "-B", stage2_profdata, "-G", "Ninja",
                      "-DCMAKE_C_COMPILER=#{stage2}/bin/clang",
                      "-DCMAKE_CXX_COMPILER=#{stage2}/bin/clang++",
                      "-DLLVM_BUILD_RUNTIMES=OFF",
                      *extra_args.reject { |s| s["TABLEGEN"] },
                      *std_cmake_args
      # This build is for profiling, so it is safe to ignore errors.
      # NOTE: If using `Unix Makefiles` generator, `-k 0` needs to replaced with `--keep-going`.
      begin
        system "cmake", "--build", stage2_profdata, "--", "-k", "0"
      rescue BuildError
        nil
      end

      # Merge the generated profile data
      profpath = stage2/"profiles"
      pgo_profile = profpath/"pgo_profile.prof"
      system stage1/"bin/llvm-profdata", "merge", "-output=#{pgo_profile}", *profpath.glob("*.profraw")

      # Make sure to build with our profiled compiler and use the profile data
      args << "-DCMAKE_C_COMPILER=#{stage1}/bin/clang"
      args << "-DCMAKE_CXX_COMPILER=#{stage1}/bin/clang++"
      args << "-DLLVM_PROFDATA_FILE=#{pgo_profile}"
      # `llvm-tblgen` is an install target, so let's build that.
      args << "-DCLANG_TABLEGEN=#{stage1}/bin/clang-tblgen"

      # Silence some warnings
      ENV.append_to_cflags "-Wno-backend-plugin"

      # Since we don't build lld in final stage, `-fuse-ld=lld` needs to find stage1 lld in PATH
      ENV.append_path "PATH", stage1/"bin" if OS.linux?
    end

    if ENV.cflags.present?
      args << "-DCMAKE_C_FLAGS=#{ENV.cflags}"
      runtimes_cmake_args << "-DCMAKE_C_FLAGS=#{ENV.cflags}"
      builtins_cmake_args << "-DCMAKE_C_FLAGS=#{ENV.cflags}"
    end
    if ENV.cxxflags.present?
      args << "-DCMAKE_CXX_FLAGS=#{ENV.cxxflags}"
      runtimes_cmake_args << "-DCMAKE_CXX_FLAGS=#{ENV.cxxflags}"
      builtins_cmake_args << "-DCMAKE_CXX_FLAGS=#{ENV.cxxflags}"
    end
    args << "-DRUNTIMES_CMAKE_ARGS=#{runtimes_cmake_args.join(";")}" if runtimes_cmake_args.present?
    args << "-DBUILTINS_CMAKE_ARGS=#{builtins_cmake_args.join(";")}" if builtins_cmake_args.present?

    # Now, we can build.
    system "cmake", "-S", llvmpath, "-B", "build", "-G", "Ninja", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "install"

    clang_config_file_dir.mkpath
    touch clang_config_file_dir/".keepme"
    (prefix/"etc").install_symlink clang_config_file_dir

    if OS.mac?
      # Get the version from `llvm-config` to get the correct HEAD or RC version too.
      llvm_version = Utils.safe_popen_read(bin/"llvm-config", "--version").strip
      soversion = Version.new(llvm_version).major.to_s
      soversion << "git" if llvm_version.end_with?("git")
      if (match = llvm_version.match(/-rc\d*$/))
        soversion << match[0]
      end

      # Install versioned symlink, or else `llvm-config` doesn't work properly
      lib.install_symlink "libLLVM.dylib" => "libLLVM-#{soversion}.dylib"

      # Install Xcode toolchain. See:
      # https://github.com/llvm/llvm-project/blob/main/llvm/tools/xcode-toolchain/CMakeLists.txt
      # We do this manually in order to avoid:
      #   1. installing duplicates of files in the prefix
      #   2. requiring an existing Xcode installation
      xctoolchain = prefix/"Toolchains/LLVM#{llvm_version}.xctoolchain"

      system "/usr/libexec/PlistBuddy", "-c", "Add:CFBundleIdentifier string org.llvm.#{llvm_version}", "Info.plist"
      system "/usr/libexec/PlistBuddy", "-c", "Add:CompatibilityVersion integer 2", "Info.plist"
      xctoolchain.install "Info.plist"
      (xctoolchain/"usr").install_symlink [bin, include, lib, libexec, share]

      # Install a major-versioned symlink that can be used across minor/patch version upgrades.
      xctoolchain.parent.install_symlink xctoolchain.basename.to_s => "LLVM#{soversion}.xctoolchain"

      # Write config files for each macOS major version so that this works across OS upgrades.
      MacOSVersion::SYMBOLS.each_value do |v|
        macos_version = MacOSVersion.new(v)
        write_config_files(macos_version, MacOSVersion.kernel_major_version(macos_version), Hardware::CPU.arch)
      end

      # Also write an unversioned config file as fallback
      write_config_files("", "", Hardware::CPU.arch)
    end

    # Install Vim plugins
    %w[ftdetect ftplugin indent syntax].each do |dir|
      (share/"vim/vimfiles"/dir).install Pathname.glob("*/utils/vim/#{dir}/*.vim")
    end

    # Install Emacs modes
    elisp.install llvmpath.glob("utils/emacs/*.el") + share.glob("clang/*.el")

    # Install C/Fortran header. This is supposed to be installed by Flang to be used by Clang;
    # however, Homebrew's layout results in it getting installed to an incompatible location.
    # Fedora packages the header in `clang-libs` and Debian in `libclang-common-*-dev` so
    # it is likely safe to install even when Flang is not installed.
    unless versioned_formula?
      resource_dir = Pathname(Utils.safe_popen_read(bin/"clang", "-print-resource-dir").chomp)
      (resource_dir/"include").install "flang/include/flang/ISO_Fortran_binding.h"
    end

    return unless lto_build

    # Convert LTO-generated bitcode in our static archives to MachO. Adapted from Fedora:
    # https://src.fedoraproject.org/rpms/redhat-rpm-config/blob/rawhide/f/brp-llvm-compile-lto-elf
    lib.glob("*.a").each do |static_archive|
      mktemp do
        system bin/"llvm-ar", "x", static_archive
        rebuilt_files = []

        Pathname.glob("*.o").each do |bc_file|
          file_type = Utils.safe_popen_read("file", "--brief", bc_file)
          next unless file_type.match?(/^LLVM (IR )?bitcode/)

          rebuilt_files << bc_file
          system bin/"clang", "-fno-lto", "-Wno-unused-command-line-argument",
                              "-x", "ir", bc_file, "-c", "-o", bc_file
        end

        system bin/"llvm-ar", "r", static_archive, *rebuilt_files if rebuilt_files.present?
      end
    end
  end

  # We use the extra layer of indirection in `arch` because the FormulaAudit/OnSystemConditionals
  # doesn't want to let us use `Hardware::CPU.arch` outside of `install` or `post_install` blocks.
  def write_config_files(macos_version, kernel_version, arch)
    require "utils/clang"

    Utils::Clang.write_system_config_files(
      config_dir:     clang_config_file_dir,
      macos_version:,
      kernel_version:,
      arch:,
    )
  end

  post_install_steps do
    configure_clang_system
  end

  def caveats
    s = <<~EOS
      CLANG_CONFIG_FILE_SYSTEM_DIR: #{clang_config_file_dir}
      CLANG_CONFIG_FILE_USER_DIR:   ~/.config/clang

      LLD and LLDB are now provided in separate formulae:
        brew install lld
        brew install lldb

      Z3 solver support will be removed in LLVM 24 as it is unsupported upstream,
      see https://github.com/llvm/llvm-project/pull/205370
    EOS

    on_macos do
      s += <<~EOS

        Using `clang`, `clang++`, etc., requires a CLT installation at `/Library/Developer/CommandLineTools`.
        If you don't want to install the CLT, you can write appropriate configuration files pointing to your
        SDK at ~/.config/clang.

        To use the bundled libunwind please use the following LDFLAGS:
          LDFLAGS="-L#{opt_lib}/unwind -lunwind"

        To use the bundled libc++ please use the following LDFLAGS:
          LDFLAGS="-L#{opt_lib}/c++ -L#{opt_lib}/unwind -lunwind"
        Features newer than system libc++ will require the following define to enable
        (support for this may be removed in a future major LLVM release):
          CPPFLAGS="-D_LIBCPP_DISABLE_AVAILABILITY"

        NOTE: You probably want to use the libunwind and libc++ provided by macOS unless you know what you're doing.
      EOS
    end

    s
  end

  test do
    alt_location_libs = [
      shared_library("libc++", "*"),
      shared_library("libc++abi", "*"),
      shared_library("libunwind", "*"),
    ]
    assert_empty lib.glob(alt_location_libs) if OS.mac?

    llvm_version = Utils.safe_popen_read(bin/"llvm-config", "--version").strip
    llvm_version_major = Version.new(llvm_version).major.to_s
    soversion = llvm_version_major.dup

    if llvm_version.end_with?("git")
      soversion << "git"
    elsif (match = llvm_version.match(/-rc\d*$/))
      soversion << match[0]
    else
      assert_equal version, llvm_version
    end

    assert_equal prefix.to_s, shell_output("#{bin}/llvm-config --prefix").chomp
    assert_equal "-lLLVM-#{soversion}", shell_output("#{bin}/llvm-config --libs").chomp
    assert_equal (lib/shared_library("libLLVM-#{soversion}")).to_s,
                 shell_output("#{bin}/llvm-config --libfiles").chomp

    (testpath/"test.c").write <<~'C'
      #include <stdio.h>
      int main()
      {
        printf("Hello World!\n");
        return 0;
      }
    C

    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <string>
      int main()
      {
        std::string str = "Hello World!";
        std::size_t str_hash = std::hash<std::string>{}(str);
        std::cout << str << std::endl;
        return 0;
      }
    CPP

    system bin/"clang-cpp", "-v", "test.c"
    system bin/"clang-cpp", "-v", "test.cpp"

    # Testing default toolchain and SDK location.
    system bin/"clang++", "-v", "-std=c++11", "test.cpp", "-o", "test++"
    assert_includes MachO::Tools.dylibs("test++"), "/usr/lib/libc++.1.dylib" if OS.mac?
    assert_equal "Hello World!", shell_output("./test++").chomp
    system bin/"clang", "-v", "test.c", "-o", "test"
    assert_equal "Hello World!", shell_output("./test").chomp

    # These tests should ignore the usual SDK includes
    with_env(CPATH: nil) do
      # Testing Command Line Tools
      if OS.mac? && MacOS::CLT.installed?
        toolchain_path = "/Library/Developer/CommandLineTools"
        cpp_base = (MacOS.version >= :big_sur) ? MacOS::CLT.sdk_path : toolchain_path
        system bin/"clang++", "-v",
               "--no-default-config",
               "-isysroot", MacOS::CLT.sdk_path,
               "-isystem", "#{cpp_base}/usr/include/c++/v1",
               "-isystem", "#{MacOS::CLT.sdk_path}/usr/include",
               "-isystem", "#{toolchain_path}/usr/include",
               "-std=c++11", "test.cpp", "-o", "testCLT++"
        assert_includes MachO::Tools.dylibs("testCLT++"), "/usr/lib/libc++.1.dylib"
        assert_equal "Hello World!", shell_output("./testCLT++").chomp
        system bin/"clang", "-v", "test.c", "-o", "testCLT"
        assert_equal "Hello World!", shell_output("./testCLT").chomp

        targets = ["#{Hardware::CPU.arch}-apple-macosx#{MacOS.full_version}"]

        # The test tends to time out on Intel, so let's do these only for ARM macOS.
        if Hardware::CPU.arm?
          old_macos_version = HOMEBREW_MACOS_OLDEST_SUPPORTED.to_i - 1
          targets << "#{Hardware::CPU.arch}-apple-macosx#{old_macos_version}"

          old_kernel_version = MacOSVersion.kernel_major_version(MacOSVersion.new(old_macos_version.to_s))
          targets << "#{Hardware::CPU.arch}-apple-darwin#{old_kernel_version}"
        end

        targets.each do |target|
          system bin/"clang-cpp", "-v", "--target=#{target}", "test.c"
          system bin/"clang-cpp", "-v", "--target=#{target}", "test.cpp"

          system bin/"clang", "-v", "--target=#{target}", "test.c", "-o", "test-macosx"
          assert_equal "Hello World!", shell_output("./test-macosx").chomp

          system bin/"clang++", "-v", "--target=#{target}", "-std=c++11", "test.cpp", "-o", "test++-macosx"
          assert_equal "Hello World!", shell_output("./test++-macosx").chomp
        end
      end

      # Testing Xcode
      if OS.mac? && MacOS::Xcode.installed?
        cpp_base = (MacOS::Xcode.version >= "12.5") ? MacOS::Xcode.sdk_path : MacOS::Xcode.toolchain_path
        system bin/"clang++", "-v",
               "--no-default-config",
               "-isysroot", MacOS::Xcode.sdk_path,
               "-isystem", "#{cpp_base}/usr/include/c++/v1",
               "-isystem", "#{MacOS::Xcode.sdk_path}/usr/include",
               "-isystem", "#{MacOS::Xcode.toolchain_path}/usr/include",
               "-std=c++11", "test.cpp", "-o", "testXC++"
        assert_includes MachO::Tools.dylibs("testXC++"), "/usr/lib/libc++.1.dylib"
        assert_equal "Hello World!", shell_output("./testXC++").chomp
        system bin/"clang", "-v",
               "-isysroot", MacOS.sdk_path,
               "test.c", "-o", "testXC"
        assert_equal "Hello World!", shell_output("./testXC").chomp
      end

      # link against installed libc++
      # related to https://github.com/Homebrew/legacy-homebrew/issues/47149
      cxx_libdir = OS.mac? ? opt_lib/"c++" : opt_lib
      system bin/"clang++", "-v",
             "-isystem", "#{opt_include}/c++/v1",
             "-std=c++11", "-stdlib=libc++", "test.cpp", "-o", "testlibc++",
             "-rtlib=compiler-rt", "-L#{cxx_libdir}", "-Wl,-rpath,#{cxx_libdir}"
      assert_includes (testpath/"testlibc++").dynamically_linked_libraries,
                      (cxx_libdir/shared_library("libc++", "1")).to_s
      (testpath/"testlibc++").dynamically_linked_libraries.each do |lib|
        refute_match(/libstdc\+\+/, lib)
        refute_match(/libgcc/, lib)
        refute_match(/libatomic/, lib)
      end
      assert_equal "Hello World!", shell_output("./testlibc++").chomp
    end

    if OS.linux?
      # Link installed libc++, libc++abi, and libunwind archives both into
      # a position independent executable (PIE), as well as into a fully
      # position independent (PIC) DSO for things like plugins that export
      # a C-only API but internally use C++.
      #
      # FIXME: It'd be nice to be able to use flags like `-static-libstdc++`
      # together with `-stdlib=libc++` (the latter one we need anyways for
      # headers) to achieve this but those flags don't set up the correct
      # search paths or handle all of the libraries needed by `libc++` when
      # linking statically.

      system bin/"clang++", "-v", "-o", "test_pie_runtimes",
             "-pie", "-fPIC", "test.cpp", "-L#{opt_lib}",
             "-stdlib=libc++", "-rtlib=compiler-rt",
             "-static-libstdc++", "-lpthread", "-ldl"
      assert_equal "Hello World!", shell_output("./test_pie_runtimes").chomp
      (testpath/"test_pie_runtimes").dynamically_linked_libraries.each do |lib|
        refute_match(/lib(std)?c\+\+/, lib)
        refute_match(/libgcc/, lib)
        refute_match(/libatomic/, lib)
        refute_match(/libunwind/, lib)
      end

      (testpath/"test_plugin.cpp").write <<~CPP
        #include <iostream>
        __attribute__((visibility("default")))
        extern "C" void run_plugin() {
          std::cout << "Hello Plugin World!" << std::endl;
        }
      CPP
      (testpath/"test_plugin_main.c").write <<~C
        extern void run_plugin();
        int main() {
          run_plugin();
        }
      C
      system bin/"clang++", "-v", "-o", "test_plugin.so",
             "-shared", "-fPIC", "test_plugin.cpp", "-L#{opt_lib}",
             "-stdlib=libc++", "-rtlib=compiler-rt",
             "-static-libstdc++", "-lpthread", "-ldl"
      system bin/"clang", "-v",
             "test_plugin_main.c", "-o", "test_plugin_libc++",
             "test_plugin.so", "-Wl,-rpath=#{testpath}", "-rtlib=compiler-rt"
      assert_equal "Hello Plugin World!", shell_output("./test_plugin_libc++").chomp
      (testpath/"test_plugin.so").dynamically_linked_libraries.each do |lib|
        refute_match(/lib(std)?c\+\+/, lib)
        refute_match(/libgcc/, lib)
        refute_match(/libatomic/, lib)
        refute_match(/libunwind/, lib)
      end
    end

    # Testing mlir
    (testpath/"test.mlir").write <<~MLIR
      func.func @main() {return}

      // -----

      // expected-note @+1 {{see existing symbol definition here}}
      func.func @foo() { return }

      // ----

      // expected-error @+1 {{redefinition of symbol named 'foo'}}
      func.func @foo() { return }
    MLIR
    system bin/"mlir-opt", "--split-input-file", "--verify-diagnostics", "test.mlir"

    (testpath/"scanbuildtest.cpp").write <<~CPP
      #include <iostream>
      int main() {
        int *i = new int;
        *i = 1;
        delete i;
        std::cout << *i << std::endl;
        return 0;
      }
    CPP
    assert_includes shell_output("#{bin}/scan-build make scanbuildtest 2>&1"),
                    "warning: Use of memory after it is released"

    (testpath/"clangformattest.c").write <<~C
      int    main() {
          printf("Hello world!"); }
    C
    assert_equal "int main() { printf(\"Hello world!\"); }\n",
      shell_output("#{bin}/clang-format -style=google clangformattest.c")

    # This will fail if the clang bindings cannot find `libclang`.
    with_env(PYTHONPATH: prefix/Language::Python.site_packages(python3)) do
      system python3, "-c", <<~PYTHON
        from clang import cindex
        cindex.Config().get_cindex_library()
      PYTHON
    end

    unless versioned_formula?
      (testpath/"omptest.c").write <<~C
        #include <stdlib.h>
        #include <stdio.h>
        #include <omp.h>
        int main() {
            #pragma omp parallel num_threads(4)
            {
              printf("Hello from thread %d, nthreads %d\\n", omp_get_thread_num(), omp_get_num_threads());
            }
            return EXIT_SUCCESS;
        }
      C

      system bin/"clang", "-fopenmp", "omptest.c", "-o", "omptest"
      testresult = shell_output("./omptest")

      sorted_testresult = testresult.split("\n").sort.join("\n")
      expected_result = <<~EOS
        Hello from thread 0, nthreads 4
        Hello from thread 1, nthreads 4
        Hello from thread 2, nthreads 4
        Hello from thread 3, nthreads 4
      EOS
      assert_equal expected_result.strip, sorted_testresult.strip

      # Test static analyzer
      (testpath/"unreachable.c").write <<~C
        unsigned int func(unsigned int a) {
          unsigned int *z = 0;
          if ((a & 1) && ((a & 1) ^1))
            return *z; // unreachable
          return 0;
        }
      C
      system bin/"clang", "--analyze", "-Xanalyzer", "-analyzer-constraints=unsupported-z3", "unreachable.c"
    end

    # Ensure LLVM did not regress output of `llvm-config --system-libs` which for a time
    # was known to output incorrect linker flags; e.g., `-llibxml2.tbd` instead of `-lxml2`.
    # On the other hand, note that a fully qualified path to `dylib` or `tbd` is OK, e.g.,
    # `/usr/local/lib/libxml2.tbd` or `/usr/local/lib/libxml2.dylib`.
    abs_path_exts = [".tbd", ".dylib"]
    shell_output("#{bin}/llvm-config --system-libs").chomp.strip.split.each do |lib|
      if lib.start_with?("-l")
        assert !lib.end_with?(".tbd"), "expected abs path when lib reported as .tbd"
        assert !lib.end_with?(".dylib"), "expected abs path when lib reported as .dylib"
      else
        p = Pathname.new(lib)
        if abs_path_exts.include?(p.extname)
          assert p.absolute?, "expected abs path when lib reported as .tbd or .dylib"
        end
      end
    end

    return if OS.linux?
    return unless clang_config_file_dir.exist? # https://github.com/Homebrew/homebrew-test-bot/issues/805

    assert_match("Configuration file: #{opt_prefix}/etc/clang/",
                 shell_output("#{opt_bin}/clang --version -no-canonical-prefixes"))
  end
end
