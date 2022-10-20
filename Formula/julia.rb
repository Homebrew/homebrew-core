class Julia < Formula
  desc "Fast, Dynamic Programming Language"
  homepage "https://julialang.org/"
  # Use the `-full` tarball to avoid having to download during the build.
  url "https://github.com/JuliaLang/julia/releases/download/v1.8.2/julia-1.8.2-full.tar.gz"
  sha256 "e57cfc2e6d891750a47f7cf03559a4e8f7212bf54900f26a9f12fd6d009d4ca9"
  license all_of: ["MIT", "BSD-3-Clause", "Apache-2.0", "BSL-1.0"]
  head "https://github.com/JuliaLang/julia.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "709aecb9811746da794677bf07f0a3a6396768ad715348cc33a71d0e8bca5ed6"
    sha256 cellar: :any,                 arm64_big_sur:  "e97d48a33a90a7ac84bae7d02b48d392b3f6d3b0194b75a5e2f196b1bc1c8183"
    sha256 cellar: :any,                 monterey:       "a4aa99fbde0335553fbbab61e07ac6236f17071444a0c2534ba585cf9ca34a1c"
    sha256 cellar: :any,                 big_sur:        "f914a713b16d7d612ed9783f9f165c1b70fe90eed292f22573bff639b9c559fc"
    sha256 cellar: :any,                 catalina:       "c9aa2fcb82e0e77607a8d58c4f0dac242a79d78b30d6037e02e8900947a228ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84732f9d71aae11b3a5c896db0cf726f7f976490ab2ecd62818749464fcc3759"
  end

  depends_on "cmake" => :build # Needed to build LLVM
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
  depends_on "suite-sparse"
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
  # https://github.com/JuliaLang/julia/pull/46240
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/dd7279eea22d92688d2a821c245d92c4f8406fcf/julia/libgcc_s.diff"
    sha256 "f12c11db53390145b4a9b1ea3b412019eee89c0d197eef6c78b0565bf7fd7aaf"
  end

  def install
    # Build documentation available at
    # https://github.com/JuliaLang/julia/blob/v#{version}/doc/build/build.md
    args = %W[
      VERBOSE=1
      USE_BINARYBUILDER=0
      prefix=#{prefix}
      sysconfdir=#{etc}
      USE_SYSTEM_CSL=1
      USE_SYSTEM_PCRE=1
      USE_SYSTEM_OPENLIBM=1
      USE_SYSTEM_BLAS=1
      USE_SYSTEM_LAPACK=1
      USE_SYSTEM_GMP=1
      USE_SYSTEM_MPFR=1
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
      LOCALBASE=#{HOMEBREW_PREFIX}
      MACOSX_VERSION_MIN=#{MacOS.version}
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
      ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/julia"
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
