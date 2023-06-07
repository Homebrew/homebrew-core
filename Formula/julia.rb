class Julia < Formula
  desc "Fast, Dynamic Programming Language"
  homepage "https://julialang.org/"
  license all_of: ["MIT", "BSD-3-Clause", "Apache-2.0", "BSL-1.0"]
  head "https://github.com/JuliaLang/julia.git", branch: "master"

  # TODO: Remove stable block when patch is no longer needed.
  stable do
    # Use the `-full` tarball to avoid having to download during the build.
    #
    # TODO: Use system `suite-sparse` when `julia` supports v7.
    # Issue ref: https://github.com/JuliaLang/julia/issues/47884
    url "https://github.com/JuliaLang/julia/releases/download/v1.9.0/julia-1.9.0-full.tar.gz"
    sha256 "222eb533c9dc54734949eb3a4169f54aefa1bc20be385fc1cf798c8219fe6400"

    # Fix printing of BigFloats with new MPFR.
    # https://github.com/Homebrew/homebrew-core/issues/131422
    patch do
      url "https://github.com/JuliaLang/julia/commit/5d43397ee52323f1c015513b2be3909078b646ef.patch?full_index=1"
      sha256 "15f9f2a7b6ae21aa5de8655970c673a953e1d46018e901f7fff98aead8e4a929"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "b41974b6aaa14c109906f794e5034029ab317f3ccc78761faa027521e3c0b890"
    sha256 cellar: :any, arm64_monterey: "50d51e910e5d119e5930dbe7bb4bf6a36473f49a6d5a35c99765223d07944c25"
    sha256 cellar: :any, arm64_big_sur:  "85f03281e67b24a57f077cfd28138ce3e1ed9c8a7ce1695a9919ddbc3508840a"
    sha256 cellar: :any, ventura:        "c823fd8e2921da2a3d92e734036600261b6e52f66e49ab1aa6a2f6638d6836db"
    sha256 cellar: :any, monterey:       "accaca15b37d74416130bfbec1b2d864ac38f5bee3c22bc7438348b1476c60ed"
    sha256 cellar: :any, big_sur:        "abca585d388288ca9e279b32199a3fd9ae2c3384ccf7ff2bd582d13ba73ec705"
  end

  depends_on "cmake" => :build # Needed to build LLVM
  depends_on "suite-sparse" => :test # Check bundled copy is used
  depends_on "ca-certificates"
  depends_on "curl"
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "libgit2"
  depends_on "libnghttp2"
  depends_on "libssh2"
  depends_on "mbedtls@2"
  depends_on "mpfr"
  depends_on "openblas"
  depends_on "openlibm"
  depends_on "p7zip"
  depends_on "pcre2"
  depends_on "utf8proc"

  uses_from_macos "perl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "patchelf" => :build
  end

  conflicts_with "juliaup", because: "both install `julia` binaries"

  fails_with gcc: "5"

  # Link against libgcc_s.1.1.dylib, not libgcc_s.1.dylib
  # https://github.com/JuliaLang/julia/issues/48056
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/202ccbabd44bd5ab02fbdee2f51f87bb88d74417/julia/libgcc_s-1.8.5.diff"
    sha256 "1eea77d8024ad8bc9c733a0e0770661bc08228d335b20c4696350ed5dfdab29a"
  end

  def install
    # Build documentation available at
    # https://github.com/JuliaLang/julia/blob/v#{version}/doc/build/build.md
    args = %W[
      prefix=#{prefix}
      sysconfdir=#{etc}
      LOCALBASE=#{HOMEBREW_PREFIX}
      MACOSX_VERSION_MIN=#{MacOS.version}
      PYTHON=python3
      USE_BINARYBUILDER=0
      USE_SYSTEM_BLAS=1
      USE_SYSTEM_CSL=1
      USE_SYSTEM_CURL=1
      USE_SYSTEM_GMP=1
      USE_SYSTEM_LAPACK=1
      USE_SYSTEM_LIBGIT2=1
      USE_SYSTEM_LIBSSH2=1
      USE_SYSTEM_LIBSUITESPARSE=0
      USE_SYSTEM_MBEDTLS=1
      USE_SYSTEM_MPFR=1
      USE_SYSTEM_NGHTTP2=1
      USE_SYSTEM_OPENLIBM=1
      USE_SYSTEM_P7ZIP=1
      USE_SYSTEM_PATCHELF=1
      USE_SYSTEM_PCRE=1
      USE_SYSTEM_UTF8PROC=1
      USE_SYSTEM_ZLIB=1
      VERBOSE=1
      LIBBLAS=-lopenblas
      LIBBLASNAME=libopenblas
      LIBLAPACK=-lopenblas
      LIBLAPACKNAME=libopenblas
      USE_BLAS64=0
    ]

    # Set MARCH and JULIA_CPU_TARGET to ensure Julia works on machines we distribute to.
    # Values adapted from https://github.com/JuliaCI/julia-buildbot/blob/master/master/inventory.py
    args << "MARCH=#{Hardware.oldest_cpu}" if Hardware::CPU.intel?

    cpu_targets = ["generic"]
    cpu_targets += if Hardware::CPU.arm?
      %w[cortex-a57 thunderx2t99 armv8.2-a,crypto,fullfp16,lse,rdm]
    else
      %w[sandybridge,-xsaveopt,clone_all haswell,-rdrnd,base(1)]
    end
    args << "JULIA_CPU_TARGET=#{cpu_targets.join(";")}" if build.stable?
    args << "TAGGED_RELEASE_BANNER=Built by #{tap.user} (v#{pkg_version})"

    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/julia"
    # Help Julia find keg-only dependencies
    deps.map(&:to_formula).select(&:keg_only?).map(&:opt_lib).each do |libdir|
      ENV.append "LDFLAGS", "-Wl,-rpath,#{libdir}"
    end

    gcc = Formula["gcc"]
    gcclibdir = gcc.opt_lib/"gcc/current"
    if OS.mac?
      ENV.append "LDFLAGS", "-Wl,-rpath,#{gcclibdir}"
      # List these two last, since we want keg-only libraries to be found first
      ENV.append "LDFLAGS", "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"
      ENV.append "LDFLAGS", "-Wl,-rpath,/usr/lib" # Needed to find macOS zlib.
    else
      ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}"
    end

    # Remove library versions from MbedTLS_jll, nghttp2_jll and others
    # https://git.archlinux.org/svntogit/community.git/tree/trunk/julia-hardcoded-libs.patch?h=packages/julia
    %w[MbedTLS nghttp2 LibGit2 OpenLibm].each do |dep|
      (buildpath/"stdlib").glob("**/#{dep}_jll.jl") do |jll|
        inreplace jll, %r{@rpath/lib(\w+)(\.\d+)*\.dylib}, "@rpath/lib\\1.dylib"
        inreplace jll, /lib(\w+)\.so(\.\d+)*/, "lib\\1.so"
      end
    end

    # Make Julia use a CA cert from `ca-certificates`
    (buildpath/"usr/share/julia").install_symlink Formula["ca-certificates"].pkgetc/"cert.pem"

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

    # Keep Julia's CA cert in sync with ca-certificates'
    pkgshare.install_symlink Formula["ca-certificates"].pkgetc/"cert.pem"
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

    # Check that installing packages works.
    # https://github.com/orgs/Homebrew/discussions/2749
    system bin/"julia", *args, "--eval", 'using Pkg; Pkg.add("Example")'

    # Check that Julia can load stdlibs that load non-Julia code.
    # Most of these also check that Julia can load Homebrew-provided libraries.
    jlls = %w[
      MPFR_jll SuiteSparse_jll Zlib_jll OpenLibm_jll
      nghttp2_jll MbedTLS_jll LibGit2_jll GMP_jll
      OpenBLAS_jll CompilerSupportLibraries_jll dSFMT_jll LibUV_jll
      LibSSH2_jll LibCURL_jll libLLVM_jll PCRE2_jll
    ]
    system bin/"julia", *args, "--eval", "using #{jlls.join(", ")}"

    # Check that Julia can load libraries in lib/"julia".
    # Most of these are symlinks to Homebrew-provided libraries.
    # This also checks that these libraries can be loaded even when
    # the symlinks are broken (e.g. by version bumps).
    libs = (lib/"julia").glob(shared_library("*"))
                        .map(&:basename)
                        .map(&:to_s)
                        .reject do |name|
                          name.start_with?("sys", "libjulia-internal", "libccalltest")
                        end

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
