class Julia < Formula
  desc "Fast, Dynamic Programming Language"
  homepage "https://julialang.org/"
  license all_of: ["MIT", "BSD-3-Clause", "Apache-2.0", "BSL-1.0"]
  head "https://github.com/JuliaLang/julia.git"

  stable do
    url "https://github.com/JuliaLang/julia/releases/download/v1.6.1/julia-1.6.1.tar.gz"
    sha256 "366b8090bd9b2f7817ce132170d569dfa3435d590a1fa5c3e2a75786bd5cdfd5"

    # https://github.com/JuliaLang/julia/issues/36617
    depends_on arch: :x86_64

    # Allow flisp to be built against system utf8proc. Remove in 1.6.2
    # https://github.com/JuliaLang/julia/pull/37723
    patch do
      url "https://github.com/JuliaLang/julia/commit/ba653ecb1c81f1465505c2cea38b4f8149dd20b3.patch?full_index=1"
      sha256 "e626ee968e2ce8207c816f39ef9967ab0b5f50cad08a46b1df15d7bf230093cb"
    end
  end

  bottle do
    sha256 cellar: :any, big_sur:  "d010756c2b3e9bdc72edda8e27078399d779f3b56a2b1c78b28c47f89f269559"
    sha256 cellar: :any, catalina: "750cec427377d71a4f8b537a19976e2a63df820216244a0d7d9a8f0a913266f0"
    sha256 cellar: :any, mojave:   "b5e9f67413ecebdbc92fec00940b84c032ec0f25f1f0a4c1398fad4ed591ef1f"
  end

  depends_on "python@3.9" => :build
  depends_on "curl"
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "llvm"
  depends_on "mbedtls"
  depends_on "mpfr"
  depends_on "nghttp2"
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
    depends_on "libunwind"
  end

  def install
    # Build documentation available at
    # https://github.com/JuliaLang/julia/blob/v#{version}/doc/build/build.md
    args = %W[
      VERBOSE=1
      USE_BINARYBUILDER=0
      prefix=#{prefix}
      USE_SYSTEM_LLVM=1
      USE_SYSTEM_PCRE=1
      USE_SYSTEM_OPENLIBM=1
      USE_SYSTEM_BLAS=1
      USE_SYSTEM_LAPACK=1
      USE_SYSTEM_GMP=1
      USE_SYSTEM_MPFR=1
      USE_SYSTEM_SUITESPARSE=1
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

    # ARM gcc does not provide `libquadmath`
    args << "USE_SYSTEM_CSL=1" unless Hardware::CPU.arm?

    # `USE_SYSTEM_SUITESPARSE` was renamed in
    # https://github.com/JuliaLang/julia/commit/835f65d9b9f54e0a8dd856fc940a188f87a48cda
    args << "USE_SYSTEM_LIBSUITESPARSE=1" if build.head?

    # Stable uses `libosxunwind` which is not in Homebrew/core
    # https://github.com/JuliaLang/julia/pull/39127
    on_macos { args << "USE_SYSTEM_LIBUNWIND=1" if build.head? }
    on_linux { args << "USE_SYSTEM_LIBUNWIND=1" }

    args << "TAGGED_RELEASE_BANNER=Built by #{tap.user} (v#{pkg_version})"

    gcc = Formula["gcc"]
    gcclibdir = gcc.opt_lib/"gcc"/gcc.any_installed_version.major
    on_macos do
      deps.map(&:to_formula).select(&:keg_only?).map(&:opt_lib).each do |libdir|
        ENV.append "LDFLAGS", "-Wl,-rpath,#{libdir}"
      end
      ENV.append "LDFLAGS", "-Wl,-rpath,#{gcclibdir}" unless Hardware::CPU.arm?
      # List these two last, since we want keg-only libraries to be found first
      ENV.append "LDFLAGS", "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"
      ENV.append "LDFLAGS", "-Wl,-rpath,/usr/lib"
    end

    on_linux do
      ENV.append "LDFLAGS", "-Wl,-rpath,#{opt_lib}"
      ENV.append "LDFLAGS", "-Wl,-rpath,#{opt_lib}/julia"
    end

    inreplace "Make.inc" do |s|
      s.change_make_var! "LOCALBASE", HOMEBREW_PREFIX
    end

    # Remove library versions from MbedTLS_jll, nghttp2_jll and libLLVM_jll
    # https://git.archlinux.org/svntogit/community.git/tree/trunk/julia-hardcoded-libs.patch?h=packages/julia
    %w[MbedTLS nghttp2].each do |dep|
      (buildpath/"stdlib").glob("**/#{dep}_jll.jl") do |jll|
        inreplace jll, %r{@rpath/lib(\w+)(\.\d+)*\.dylib}, "@rpath/lib\\1.dylib"
        inreplace jll, /lib(\w+)\.so(\.\d+)*/, "lib\\1.so"
      end
    end
    inreplace (buildpath/"stdlib").glob("**/libLLVM_jll.jl"), /libLLVM-\d+jl\.so/, "libLLVM.so"

    # Make Julia use a CA cert from OpenSSL
    (buildpath/"usr/share/julia").install_symlink Formula["openssl@1.1"].pkgetc/"cert.pem"

    system "make", *args, "install"

    if args.include? "USE_SYSTEM_CSL=1"
      # Create copies of the necessary gcc libraries in `buildpath/"usr/lib"`
      system "make", "-C", "deps", "USE_SYSTEM_CSL=1", "install-csl"
      # Install gcc library symlinks where Julia expects them
      gcclibdir.glob(shared_library("*")) do |so|
        next unless (buildpath/"usr/lib"/so.basename).exist?

        # Use `ln_sf` instead of `install_symlink` to avoid referencing
        # gcc's full version and revision number in the symlink path
        ln_sf gcclibdir.relative_path_from(lib/"julia")/so.basename, lib/"julia"
      end
    end

    # Some Julia packages look for libopenblas as libopenblas64_
    (lib/"julia").install_symlink shared_library("libopenblas") => shared_library("libopenblas64_")

    # Keep Julia's CA cert in sync with OpenSSL's
    pkgshare.install_symlink Formula["openssl@1.1"].pkgetc/"cert.pem"
  end

  test do
    assert_equal "4", shell_output("#{bin}/julia -E '2 + 2'").chomp
    system bin/"julia", "-e", 'Base.runtests("core")'
  end
end
