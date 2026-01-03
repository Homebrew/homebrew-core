class LlvmMingwW64 < Formula
  desc "Cross-compilers for Windows, using LLVM and mingw-w64 headers/libraries/tools"
  homepage "https://llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/llvm-project-21.1.8.src.tar.xz"
  sha256 "4633a23617fa31a3ea51242586ea7fb1da7140e426bd62fc164261fe036aa142"
  license all_of: [
    # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
    { "Apache-2.0" => { with: "LLVM-exception" } },
    # mingw-w64
    "ZPL-2.1",
  ]
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "lld"
  depends_on "llvm"

  conflicts_with "mingw-w64", because: "both install i686 and x86_64 Windows development tools"

  resource "mingw-w64" do
    url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v13.0.0.tar.bz2"
    sha256 "5afe822af5c4edbf67daaf45eec61d538f49eef6b19524de64897c6b95828caf"
  end

  def lld
    Formula["lld"]
  end

  def llvm
    Formula["llvm"]
  end

  def target_archs
    %w[aarch64 arm64ec i686 x86_64].freeze
  end

  def tools
    %w[
      addr2line
      ar
      as
      clang
      clang++
      dlltool
      nm
      objcopy
      objdump
      ranlib
      readelf
      size
      strings
      strip
      windres
    ].freeze
  end

  def install
    resource("mingw-w64").stage do
      # Install mingw-w64 headers (shared between all archs)
      mkdir "mingw-w64-headers/build" do
        args = %W[
          --prefix=#{prefix}/generic-w64-mingw32
          --enable-idl
        ]

        system "../configure", *args
        system "make"
        system "make", "install"
      end

      target_archs.each do |arch|
        arch_dir = prefix/"toolchain-#{arch}"
        target = "#{arch}-w64-mingw32"

        # Symlink arch_dir/target/include to the shared mingw-w64 headers
        (arch_dir/target).install_symlink prefix/"generic-w64-mingw32/include"

        # Build mingw-w64 widl for all archs before any environment variables are set
        mkdir "mingw-w64-tools/widl/build-#{arch}" do
          args = %W[
            --target=#{target}
            --prefix=#{arch_dir}
            --program-prefix=#{target}-
          ]

          system "../configure", *args
          system "make"
          system "make", "install"
          bin.install_symlink arch_dir/"bin/#{target}-widl"
        end
      end
    end

    target_archs.each do |arch|
      arch_dir = prefix/"toolchain-#{arch}"
      target = "#{arch}-w64-mingw32"

      resource("mingw-w64").stage do
        ENV.llvm_clang
        ENV["AR"] = "#{llvm.opt_bin}/llvm-ar"
        ENV["AS"] = "#{llvm.opt_bin}/llvm-as"
        ENV["CC"] = "#{llvm.opt_bin}/clang -target #{target}"
        ENV["CXX"] = "#{llvm.opt_bin}/clang++ -target #{target}"
        ENV["DLLTOOL"] = "#{llvm.opt_bin}/llvm-dlltool"
        ENV["NM"] = "#{llvm.opt_bin}/llvm-nm"
        ENV["OBJDUMP"] = "#{llvm.opt_bin}/llvm-objdump"
        ENV["RANLIB"] = "#{llvm.opt_bin}/llvm-ranlib"
        ENV["RC"] = "#{llvm.opt_bin}/llvm-windres"
        ENV["STRIP"] = "#{llvm.opt_bin}/llvm-strip"

        ENV["CPPFLAGS"] = "--no-default-config -target #{target} -isystem #{arch_dir}/#{target}/include"
        ENV["RCFLAGS"] = "-I#{arch_dir}/#{target}/include"
        ENV["LDFLAGS"] = "--no-default-config -fuse-ld=lld"

        # Build the mingw-w64 runtime
        mkdir "mingw-w64-crt/build-#{arch}" do
          args = %W[
            --host=#{target}
            --prefix=#{arch_dir}/#{target}
            --with-sysroot=no
          ]

          case arch
          when "i686"
            args << "--enable-lib32" << "--disable-lib64"
          when "x86_64"
            args << "--disable-lib32" << "--enable-lib64"
          when "aarch64", "arm64ec"
            args << "--disable-lib32" << "--disable-lib64" << "--enable-libarm64"
          end

          system "../configure", *args
          system "make"
          system "make", "install"
        end

        # Build mingw-w64 winpthreads
        mkdir "mingw-w64-libraries/winpthreads/build-#{arch}" do
          args = %W[
            --host=#{target}
            --prefix=#{arch_dir}/#{target}
            --with-sysroot=no
            --disable-shared
          ]

          system "../configure", *args
          system "make"
          system "make", "install"
          (arch_dir/target/"lib/libwinpthread.la").unlink
        end
      end

      llvm_version = Utils.safe_popen_read(llvm.opt_bin/"llvm-config", "--version").strip
      llvm_major = Version.new(llvm_version).major.to_s

      # Populate our own resource directory with symlinks to the includes from Clang's resource directory,
      # and put our resource dir in libexec so it doesn't conflict with Clang's
      clang_resource_dir = Pathname(Utils.safe_popen_read(llvm.opt_bin/"clang", "-print-resource-dir").chomp)
      relative_resource_dir = clang_resource_dir.relative_path_from(llvm.prefix.realpath)
      clang_resource_dir = llvm.opt_prefix/relative_resource_dir

      my_resource_dir = libexec/"clang"/llvm_major

      clang_resource_include_dir = clang_resource_dir/"include"
      clang_resource_include_dir.find do |pn|
        next unless pn.file?

        relative_path = pn.relative_path_from(clang_resource_dir)
        target_path = my_resource_dir/relative_path
        next if target_path.exist?

        target_path.parent.mkpath
        ln_s pn, target_path
      end
      ENV.append "CPPFLAGS", "-resource-dir #{my_resource_dir}"

      common_args = %W[
        -DCMAKE_VERBOSE_MAKEFILE=ON
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_C_COMPILER=#{llvm.opt_bin}/clang
        -DCMAKE_CXX_COMPILER=#{llvm.opt_bin}/clang++
        -DCMAKE_SYSTEM_NAME=Windows
        -DCMAKE_C_COMPILER_WORKS=1
        -DCMAKE_CXX_COMPILER_WORKS=1
        -DCMAKE_ASM_COMPILER_TARGET=#{target}
        -DCMAKE_C_COMPILER_TARGET=#{target}
        -DCMAKE_CXX_COMPILER_TARGET=#{target}
      ]
      common_args << "-DCMAKE_C_FLAGS_INIT=#{ENV["CPPFLAGS"]}"
      common_args << "-DCMAKE_CXX_FLAGS_INIT=#{ENV["CPPFLAGS"]}"

      # Build LLVM compiler-rt
      mkdir "compiler-rt/build-#{arch}" do
        args = %W[
          -DCOMPILER_RT_INSTALL_PATH=#{my_resource_dir}
          -DCOMPILER_RT_BUILD_BUILTINS=TRUE
          -DCOMPILER_RT_DEFAULT_TARGET_ONLY=TRUE
          -DCOMPILER_RT_EXCLUDE_ATOMIC_BUILTIN=FALSE
          -DLLVM_CONFIG_PATH=
          -DCMAKE_FIND_ROOT_PATH=#{arch_dir}/#{target}
          -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY
          -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ONLY
          -DCOMPILER_RT_BUILD_SANITIZERS=FALSE
          -DCOMPILER_RT_BUILD_CTX_PROFILE=FALSE
          -DCOMPILER_RT_BUILD_XRAY=FALSE
          -DCOMPILER_RT_BUILD_ORC=FALSE
          -DCOMPILER_RT_BUILD_PROFILE=FALSE
          -DCOMPILER_RT_BUILD_MEMPROF=FALSE
          -DCOMPILER_RT_BUILD_LIBFUZZER=FALSE
        ]
        system "cmake", "-G", "Ninja", "..", *common_args, *args
        system "cmake", "--build", "."
        if arch == "arm64ec"
          # On ARM64EC Clang uses the aarch64 compiler-rt, merge the arm64ec lib into aarch64 rather than installing
          system llvm.opt_bin/"llvm-ar", "-qL",
                 "#{my_resource_dir}/lib/windows/libclang_rt.builtins-aarch64.a",
                 "lib/windows/libclang_rt.builtins-arm64ec.a"
        else
          system "cmake", "--build", ".", "--target", "install"
        end
      end

      ENV.append "LDFLAGS", "-rtlib=compiler-rt -stdlib=libc++ -L#{arch_dir}/#{target}/lib"

      relative_runtime_install_prefix="lib/llvm/#{llvm_major}/#{target}"

      # Build LLVM runtimes
      mkdir "runtimes/build-#{arch}" do
        args = %W[
          -DLLVM_ENABLE_RUNTIMES=libunwind;libcxxabi;libcxx
          -DLLVM_DEFAULT_TARGET_TRIPLE=#{target}
          -DCMAKE_INSTALL_PREFIX=#{prefix}/#{relative_runtime_install_prefix}
          -DLIBUNWIND_USE_COMPILER_RT=TRUE
          -DLIBUNWIND_ENABLE_SHARED=TRUE
          -DLIBCXX_USE_COMPILER_RT=TRUE
          -DLIBCXX_ENABLE_SHARED=TRUE
          -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=TRUE
          -DLIBCXX_CXX_ABI=libcxxabi
          -DLIBCXX_LIBDIR_SUFFIX=
          -DLIBCXX_INCLUDE_TESTS=FALSE
          -DLIBCXX_INSTALL_MODULES=TRUE
          -DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=FALSE
          -DLIBCXXABI_USE_COMPILER_RT=TRUE
          -DLIBCXXABI_USE_LLVM_UNWINDER=TRUE
          -DLIBCXXABI_ENABLE_SHARED=OFF
          -DLIBCXXABI_LIBDIR_SUFFIX=
        ]
        system "cmake", "-G", "Ninja", "..", *common_args, *args
        system "cmake", "--build", "."
        system "cmake", "--build", ".", "--target", "install"
      end

      # Write config file
      (etc/"clang").mkpath
      triple = Utils.safe_popen_read(llvm.opt_bin/"clang", "--target=#{target}", "--print-target-triple").chomp
      (etc/"clang/#{triple}.cfg").atomic_write <<~CONFIG
        --sysroot=#{opt_prefix}/toolchain-#{arch}/#{target}
        -resource-dir=#{my_resource_dir}
        -fuse-ld=lld
        -rtlib=compiler-rt
        -stdlib=libc++
        -unwindlib=libunwind
        -cxx-isystem#{opt_prefix}/#{relative_runtime_install_prefix}/include/c++/v1
        -L#{opt_prefix}/#{relative_runtime_install_prefix}/lib
      CONFIG

      # Create symlinks
      tools.each do |tool|
        src = (llvm.opt_bin/"llvm-#{tool}").exist? ? llvm.opt_bin/"llvm-#{tool}" : llvm.opt_bin/tool
        bin.install_symlink src => "#{target}-#{tool}"
      end

      # Create ld wrapper script
      # Ideally lld would figure this out itself when run through a triplet-prefixed symlink
      case arch
      when "i686"
        lld_target = "i386pe"
      when "x86_64"
        lld_target = "i386pep"
      when "aarch64"
        lld_target = "arm64pe"
      when "arm64ec"
        lld_target = "arm64ecpe"
      end
      (bin/"#{target}-ld").atomic_write <<~SH
        #!/bin/sh
        #{lld.opt_bin/"ld.lld"} -m #{lld_target} "$@"
      SH
    end
  end

  test do
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      #include <windows.h>
      int main() { puts("Hello world!");
        MessageBox(NULL, TEXT("Hello GUI!"), TEXT("HelloMsg"), 0); return 0; }
    C
    (testpath/"hello.cc").write <<~CPP
      #include <iostream>
      int main() { std::cout << "Hello, world!" << std::endl; return 0; }
    CPP
    # https://docs.microsoft.com/en-us/windows/win32/rpc/using-midl
    (testpath/"example.idl").write <<~MIDL
      #include "objidlbase.idl"
      [
        uuid(ba209999-0c6c-11d2-97cf-00c04f8eea45),
        version(1.0)
      ]
      interface MyInterface
      {
        const unsigned short INT_ARRAY_LEN = 100;

        void MyRemoteProc(
            [in] int param1,
            [out] int outArray[INT_ARRAY_LEN]
        );
      }
    MIDL

    ENV["LC_ALL"] = "C"
    ENV.remove_macosxsdk if OS.mac?
    target_archs.each do |arch|
      target = "#{arch}-w64-mingw32"
      outarch = case arch
      when "i686" then "i386"
      when "x86_64" then "x86-64"
      when "aarch64" then "arm64"
      else arch
      end

      system bin/"#{target}-clang", "-o", "test.exe", "hello.c"
      assert_match "file format coff-#{outarch}", shell_output("#{bin}/#{target}-objdump -a test.exe")

      system bin/"#{target}-clang++", "-o", "test.exe", "hello.cc"
      assert_match "file format coff-#{outarch}", shell_output("#{bin}/#{target}-objdump -a test.exe")

      system bin/"#{target}-widl", "example.idl"
      assert_path_exists testpath/"example_s.c", "example_s.c should have been created"
    end
  end
end
