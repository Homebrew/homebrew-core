class Julia < Formula
  desc "Fast, Dynamic Programming Language"
  homepage "https://julialang.org/"
  license all_of: ["MIT", "BSD-3-Clause", "Apache-2.0", "BSL-1.0"]

  stable do
    # Use the `-full` tarball to avoid having to download during the build.
    # TODO: Check if we can unbundle `curl`: https://github.com/JuliaLang/Downloads.jl/issues/260
    url "https://github.com/JuliaLang/julia/releases/download/v1.11.6/julia-1.11.6-full.tar.gz"
    sha256 "b268def41adc17496c3e0e7dcb5e27b2cbe6a1c61c78f6463544c5f4c734168a"

    depends_on "libgit2@1.8"

    # Link against libgcc_s.1.1.dylib, not libgcc_s.1.dylib
    # https://github.com/JuliaLang/julia/pull/56965#event-15826575851
    # Remove in 1.12
    patch do
      url "https://github.com/JuliaLang/julia/commit/75cdffeb0f37b438950534712755a4f7cebbdd8c.patch?full_index=1"
      sha256 "7b62554131a2627c70570b800c8fea35048e863ba2e11fc6c93d6fe26920cda8"
    end
  end

  # Upstream creates GitHub releases for both stable and LTS versions, so the
  # "latest" release on GitHub may be an LTS version instead of a "stable"
  # version. This checks the first-party download page, which links to the
  # `stable` tarballs from the newest releases on GitHub.
  livecheck do
    url "https://julialang.org/downloads/"
    regex(/href=.*?julia[._-]v?(\d+(?:\.\d+)+)[._-]full\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0b0383a975eb655862d9ce049595e3e0862f0def36f985f219f72256c72d9d11"
    sha256 cellar: :any,                 arm64_sonoma:  "b254d61d5a1cb1ee5388c8efe2f98c29cc2baafa19fc9d3e5c9d1286e269a88c"
    sha256                               arm64_ventura: "1e1ff07e37ff59d0a35201bf34302a7276839f149004fea472f9c63739c20f81"
    sha256 cellar: :any,                 sonoma:        "df8d978b084838485e24e5fd0894ee8968f3ab04dc964c39f7d81722758ab425"
    sha256 cellar: :any,                 ventura:       "ba39de3ea6e7eb95ccccf3d3148e09f2f8af9f299f8321bc933e2e0151f98e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afaf2efaa803943c6fc2fe79a419f69a91310d6b38a4367688784ac72ac27884"
  end

  head do
    url "https://github.com/JuliaLang/julia.git", branch: "master"

    depends_on "curl"
    depends_on "libgit2"
    depends_on "openssl@3"
  end

  depends_on "cmake" => :build # Needed to build LLVM
  depends_on "gcc" => :build # for gfortran
  depends_on "ca-certificates"
  depends_on "gmp"
  depends_on "libblastrampoline"
  depends_on "libnghttp2"
  depends_on "libssh2"
  depends_on "mpfr"
  depends_on "openblas"
  depends_on "openlibm"
  depends_on "p7zip"
  depends_on "pcre2"
  depends_on "suite-sparse"
  depends_on "utf8proc"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "ncurses" # for terminfo
  uses_from_macos "zlib"

  on_linux do
    depends_on "patchelf" => :build
  end

  conflicts_with "juliaup", because: "both install `julia` binaries"

  def install
    # Build documentation available at
    # https://github.com/JuliaLang/julia/blob/v#{version}/doc/build/build.md
    args = %W[
      prefix=#{prefix}
      sysconfdir=#{etc}
      LOCALBASE=#{HOMEBREW_PREFIX}
      PYTHON=python3
      USE_BINARYBUILDER=0
      USE_SYSTEM_BLAS=1
      USE_SYSTEM_CSL=1
      USE_SYSTEM_GMP=1
      USE_SYSTEM_LAPACK=1
      USE_SYSTEM_LIBBLASTRAMPOLINE=1
      USE_SYSTEM_LIBGIT2=1
      USE_SYSTEM_LIBSSH2=1
      USE_SYSTEM_LIBSUITESPARSE=1
      USE_SYSTEM_MPFR=1
      USE_SYSTEM_NGHTTP2=1
      USE_SYSTEM_OPENLIBM=1
      USE_SYSTEM_OPENSSL=1
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
      WITH_TERMINFO=0
    ]

    args << "MACOSX_VERSION_MIN=#{MacOS.version}" if OS.mac?

    # Set MARCH and JULIA_CPU_TARGET to ensure Julia works on machines we distribute to.
    # Values adapted from https://github.com/JuliaCI/julia-buildkite/blob/main/utilities/build_envs.sh
    args << "MARCH=#{Hardware.oldest_cpu}" if Hardware::CPU.intel?

    cpu_targets = %w[generic]
    if Hardware::CPU.arm?
      if OS.mac?
        # For Apple Silicon, we don't care about other hardware
        cpu_targets << "apple-m1,clone_all"
      else
        cpu_targets += %w[cortex-a57 thunderx2t99 carmel,clone_all
                          apple-m1,base(3) neoverse-512tvb,base(3)]
      end
    end
    if Hardware::CPU.intel?
      cpu_targets += %w[sandybridge,-xsaveopt,clone_all
                        haswell,-rdrnd,base(1)
                        x86-64-v4,-rdrnd,base(1)]
    end
    args << "JULIA_CPU_TARGET=#{cpu_targets.join(";")}"
    user = begin
      tap.user
    rescue
      "unknown user"
    end
    args << "TAGGED_RELEASE_BANNER=Built by #{user} (v#{pkg_version})"

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
      ENV["SDKROOT"] = MacOS.sdk_path
    else
      ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}"
    end

    # Remove library versions from nghttp2_jll and others
    # https://git.archlinux.org/svntogit/community.git/tree/trunk/julia-hardcoded-libs.patch?h=packages/julia
    stdlib_deps = %w[nghttp2 LibGit2 OpenLibm SuiteSparse]
    stdlib_deps.each do |dep|
      inreplace (buildpath/"stdlib").glob("**/#{dep}_jll.jl") do |s|
        s.gsub!(%r{@rpath/lib(\w+)(\.\d+)*\.dylib}, "@rpath/lib\\1.dylib")
        s.gsub!(/lib(\w+)\.so(\.\d+)*/, "lib\\1.so")
      end
    end

    # Make Julia use a CA cert from `ca-certificates`
    (buildpath/"usr/share/julia").install_symlink Formula["ca-certificates"].pkgetc/"cert.pem"

    if build.head?
      args << "USE_SYSTEM_CURL=1"
    else
      # Fix for cmake version 4 compatibility
      inreplace "deps/tools/common.mk", "CMAKE_COMMON :=", "CMAKE_COMMON := -DCMAKE_POLICY_VERSION_MINIMUM=3.5"
      args += ["USE_SYSTEM_CURL=0", "USE_SYSTEM_MBEDTLS=0"]
      # Julia 1.11 is incompatible with curl >= 8.10
      # Issue ref: https://github.com/JuliaLang/Downloads.jl/issues/260
      odie "Try unbundling curl and removing mbedtls references!" if version >= "1.12"
      # Workaround to install bundled curl without bundling other libs
      system "make", "-C", "deps", "install-mbedtls", *args
      system "make", "-C", "deps", "install-curl", *args
    end

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

    if OS.linux? || Hardware::CPU.arm?
      # Setting up test suite is slow and causes Intel macOS to exceed 5 min limit
      with_env(CI: nil) do
        system bin/"julia", *args, "--eval", 'Base.runtests("core")'
      end
    end

    # Check that installing packages works.
    # https://github.com/orgs/Homebrew/discussions/2749
    system bin/"julia", *args, "--eval", 'using Pkg; Pkg.add("Example")'

    # Check that Julia can load stdlibs that load non-Julia code.
    # Most of these also check that Julia can load Homebrew-provided libraries.
    jlls = %w[
      MPFR_jll SuiteSparse_jll Zlib_jll OpenLibm_jll
      nghttp2_jll LibGit2_jll GMP_jll
      OpenBLAS_jll CompilerSupportLibraries_jll dSFMT_jll LibUV_jll
      LibSSH2_jll LibCURL_jll libLLVM_jll PCRE2_jll
    ]
    system bin/"julia", *args, "--eval", "using #{jlls.join(", ")}"

    # Check that Julia can load libraries in lib/"julia".
    # Most of these are symlinks to Homebrew-provided libraries.
    # This also checks that these libraries can be loaded even when
    # the symlinks are broken (e.g. by version bumps).
    libs = (lib/"julia").glob(shared_library("*"))
                        .map { |library| library.basename.to_s }
                        .reject do |name|
                          name.start_with?("sys", "libjulia-internal", "libccalltest")
                        end

    (testpath/"library_test.jl").write <<~JULIA
      using Libdl
      libraries = #{libs}
      for lib in libraries
        handle = dlopen(lib)
        @assert dlclose(handle) "Unable to close $(lib)!"
      end
    JULIA
    system bin/"julia", *args, "library_test.jl"
  end
end
