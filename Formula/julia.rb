class Julia < Formula
  desc "Fast, Dynamic Programming Language"
  homepage "https://julialang.org/"
  url "https://github.com/JuliaLang/julia/releases/download/v1.6.3/julia-1.6.3.tar.gz"
  sha256 "2593def8cc9ef81663d1c6bfb8addc3f10502dd9a1d5a559728316a11dea2594"
  license all_of: ["MIT", "BSD-3-Clause", "Apache-2.0", "BSL-1.0"]
  revision 3
  head "https://github.com/JuliaLang/julia.git"

  bottle do
    sha256 cellar: :any,                 big_sur:      "b0944c27e4ab5a11289d89ab6417ecb692ed89dbba0696366f9886f75fa0da5a"
    sha256 cellar: :any,                 catalina:     "491f43d467ff4cdd51b2ef5bf8ec0c122a334f2279df5b1e89954b0a8fc4179d"
    sha256 cellar: :any,                 mojave:       "8330cf34dd9966a4fa31ef99a843024a50aab029a969f8d5f2c647e8614672bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8629b4e48728a971ba0a6dfc0272fbcba573d42ee09fab8b3cbd7902d28dc97e"
  end

  depends_on "python@3.9" => :build
  # https://github.com/JuliaLang/julia/issues/36617
  depends_on arch: :x86_64
  depends_on "curl"
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "libgit2"
  depends_on "libnghttp2"
  depends_on "libssh2"
  depends_on "llvm@12"
  depends_on "mbedtls@2"
  depends_on "mpfr"
  depends_on "openblas"
  depends_on "openlibm"
  depends_on "p7zip"
  depends_on "pcre2"
  depends_on "suite-sparse"
  depends_on "utf8proc"

  uses_from_macos "perl" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "patchelf" => :build

    # This dependency can be dropped when upstream resolves
    # https://github.com/JuliaLang/julia/issues/30154
    depends_on "libunwind"
  end

  fails_with gcc: "5"

  # Fix compatibility with LibGit2 1.2.0+
  # https://github.com/JuliaLang/julia/pull/42209
  patch do
    url "https://raw.githubusercontent.com/archlinux/svntogit-community/cec6c2023b66d88c013677bfa9965cce8e49e7ab/trunk/julia-libgit-1.2.patch"
    sha256 "c57ea92a11fa8dac72229e6a912d2372ec0d98d63486426fe3bdeeb795de48f7"
  end

  def install
    # Build documentation available at
    # https://github.com/JuliaLang/julia/blob/v#{version}/doc/build/build.md
    #
    # Remove `USE_SYSTEM_SUITESPARSE` in 1.7.0
    # https://github.com/JuliaLang/julia/commit/835f65d9b9f54e0a8dd856fc940a188f87a48cda
    args = %W[
      VERBOSE=1
      USE_BINARYBUILDER=0
      prefix=#{prefix}
      sysconfdir=#{etc}
      USE_SYSTEM_CSL=1
      USE_SYSTEM_LLVM=1
      USE_SYSTEM_PCRE=1
      USE_SYSTEM_OPENLIBM=1
      USE_SYSTEM_BLAS=1
      USE_SYSTEM_LAPACK=1
      USE_SYSTEM_GMP=1
      USE_SYSTEM_MPFR=1
      USE_SYSTEM_SUITESPARSE=1
      USE_SYSTEM_LIBSUITESPARSE=1
      USE_SYSTEM_UTF8PROC=1
      USE_SYSTEM_MBEDTLS=1
      USE_SYSTEM_LIBSSH2=1
      USE_SYSTEM_NGHTTP2=1
      USE_SYSTEM_CURL=1
      USE_SYSTEM_LIBGIT2=1
      USE_SYSTEM_PATCHELF=1
      USE_SYSTEM_ZLIB=1
      USE_SYSTEM_P7ZIP=1
      LIBBLAS=-lopenblas
      LIBBLASNAME=libopenblas
      LIBLAPACK=-lopenblas
      LIBLAPACKNAME=libopenblas
      USE_BLAS64=0
      PYTHON=python3
      MACOSX_VERSION_MIN=#{MacOS.version}
    ]

    # Set MARCH and JULIA_CPU_TARGET to ensure Julia works on machines we distribute to.
    # Values adapted from https://github.com/JuliaCI/julia-buildbot/blob/master/master/inventory.py
    march = if build.head?
      "native"
    elsif Hardware::CPU.arm?
      "armv8-a"
    else
      Hardware.oldest_cpu
    end
    args << "MARCH=#{march}"

    cpu_targets = ["generic"]
    cpu_targets += if Hardware::CPU.arm?
      %w[cortex-a57 thunderx2t99 armv8.2-a,crypto,fullfp16,lse,rdm]
    else
      %w[sandybridge,-xsaveopt,clone_all haswell,-rdrnd,base(1)]
    end
    args << "JULIA_CPU_TARGET=#{cpu_targets.join(";")}" if build.stable?

    # Stable uses `libosxunwind` which is not in Homebrew/core
    # https://github.com/JuliaLang/julia/pull/39127
    args << "USE_SYSTEM_LIBUNWIND=1" if OS.linux? || build.head?

    args << "TAGGED_RELEASE_BANNER=Built by #{tap.user} (v#{pkg_version})"

    # Help Julia find keg-only dependencies
    deps.map(&:to_formula).select(&:keg_only?).map(&:opt_lib).each do |libdir|
      ENV.append "LDFLAGS", "-Wl,-rpath,#{libdir}"

      next unless OS.linux?

      libdir.glob(shared_library("*")) do |so|
        (buildpath/"usr/lib").install_symlink so
        (lib/"julia").install_symlink so
      end
    end

    gcc = Formula["gcc"]
    gcclibdir = gcc.opt_lib/"gcc"/gcc.any_installed_version.major
    if OS.mac?
      ENV.append "LDFLAGS", "-Wl,-rpath,#{gcclibdir}"
      # List these two last, since we want keg-only libraries to be found first
      ENV.append "LDFLAGS", "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"
      ENV.append "LDFLAGS", "-Wl,-rpath,/usr/lib"
    else
      ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}"
      ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/julia"
    end

    inreplace "Make.inc" do |s|
      s.change_make_var! "LOCALBASE", HOMEBREW_PREFIX
    end

    # Remove library versions from MbedTLS_jll, nghttp2_jll and libLLVM_jll
    # https://git.archlinux.org/svntogit/community.git/tree/trunk/julia-hardcoded-libs.patch?h=packages/julia
    %w[MbedTLS nghttp2 LibGit2 OpenLibm].each do |dep|
      (buildpath/"stdlib").glob("**/#{dep}_jll.jl") do |jll|
        inreplace jll, %r{@rpath/lib(\w+)(\.\d+)*\.dylib}, "@rpath/lib\\1.dylib"
        inreplace jll, /lib(\w+)\.so(\.\d+)*/, "lib\\1.so"
      end
    end
    inreplace (buildpath/"stdlib").glob("**/libLLVM_jll.jl"), /libLLVM-\d+jl\.so/, "libLLVM.so"

    # Make Julia use a CA cert from OpenSSL
    (buildpath/"usr/share/julia").install_symlink Formula["openssl@1.1"].pkgetc/"cert.pem"

    system "make", *args, "install"

    if OS.linux?
      # Replace symlinks referencing Cellar paths with ones using opt paths
      deps.reject(&:build?).map(&:to_formula).map(&:opt_lib).each do |libdir|
        libdir.glob(shared_library("*")) do |so|
          next unless (lib/"julia"/so.basename).exist?

          ln_sf so.relative_path_from(lib/"julia"), lib/"julia"
        end
      end
    end

    # Create copies of the necessary gcc libraries in `buildpath/"usr/lib"`
    system "make", "-C", "deps", "USE_SYSTEM_CSL=1", "install-csl"
    # Install gcc library symlinks where Julia expects them
    gcclibdir.glob(shared_library("*")) do |so|
      next unless (buildpath/"usr/lib"/so.basename).exist?

      # Use `ln_sf` instead of `install_symlink` to avoid referencing
      # gcc's full version and revision number in the symlink path
      ln_sf so.relative_path_from(lib/"julia"), lib/"julia"
    end

    # Some Julia packages look for libopenblas as libopenblas64_
    (lib/"julia").install_symlink shared_library("libopenblas") => shared_library("libopenblas64_")

    # Keep Julia's CA cert in sync with OpenSSL's
    pkgshare.install_symlink Formula["openssl@1.1"].pkgetc/"cert.pem"
  end

  test do
    args = %W[
      --startup-file=no
      --history-file=no
      --project=#{testpath}
      --procs #{ENV.make_jobs}
    ]

    assert_equal "4", shell_output("#{bin}/julia #{args.join(" ")} --print '2 + 2'").chomp
    system bin/"julia", *args, "--eval", 'Base.runtests("core")'

    # Check that Julia can load stdlibs that load non-Julia code.
    # Most of these also check that Julia can load Homebrew-provided libraries.
    jlls = %w[
      MPFR_jll SuiteSparse_jll Zlib_jll OpenLibm_jll
      nghttp2_jll MbedTLS_jll LibGit2_jll GMP_jll
      OpenBLAS_jll CompilerSupportLibraries_jll dSFMT_jll LibUV_jll
      LibSSH2_jll LibCURL_jll libLLVM_jll PCRE2_jll
    ]
    system bin/"julia", *args, "--eval", "using #{jlls.join(", ")}"

    # FIXME: The test below will try, and fail, to load the unversioned LLVM's
    #        libraries since LLVM is not keg-only on Linux, but that's not what
    #        we want when Julia depends on a keg-only LLVM (which it currently does).
    llvm = deps.map(&:to_formula)
               .find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)$/) }
    return if OS.linux? && llvm.keg_only?

    # Check that Julia can load libraries in lib/"julia".
    # Most of these are symlinks to Homebrew-provided libraries.
    # This also checks that these libraries can be loaded even when
    # the symlinks are broken (e.g. by version bumps).
    dlext = shared_library("").sub(".", "")
    libs = (lib/"julia").children
                        .reject(&:directory?)
                        .map(&:basename)
                        .map(&:to_s)
                        .select { |s| s.start_with?("lib") && s.end_with?(dlext) }

    (testpath/"library_test.jl").write <<~EOS
      using Libdl
      libraries = #{libs}
      for lib in libraries
        handle = dlopen(lib)
        @assert dlclose(handle) "Unable to close $(lib)!"
      end
    EOS
    system bin/"julia", *args, "library_test.jl"
  end
end
