class Julia < Formula
  desc "Fast, Dynamic Programming Language"
  homepage "https://julialang.org/"
  url "https://github.com/JuliaLang/julia/releases/download/v1.6.3/julia-1.6.3.tar.gz"
  sha256 "2593def8cc9ef81663d1c6bfb8addc3f10502dd9a1d5a559728316a11dea2594"
  license all_of: ["MIT", "BSD-3-Clause", "Apache-2.0", "BSL-1.0"]
  revision 1
  head "https://github.com/JuliaLang/julia.git"

  bottle do
    sha256 cellar: :any,                 big_sur:      "321b88173bf2a9e5a31144afe99ae42eb75dad1a764e593d6f7ffb0bfe89db35"
    sha256 cellar: :any,                 catalina:     "148229555eb13f101a177ad112a3b6057ae9f40b1e4b772d40ad545117268499"
    sha256 cellar: :any,                 mojave:       "b7746d8dc021ad4e5a1d911ef316a3532c32bcb5ee8ab1aa493fc0797b99fad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fe24dac8d41a5aaeac1c0066795581c7664cd25d6a1a4a898e5a1f2a373dd298"
  end

  depends_on "python@3.9" => :build
  # https://github.com/JuliaLang/julia/issues/36617
  depends_on arch: :x86_64
  depends_on "curl"
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "llvm"
  depends_on "mbedtls@2"
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

    # This dependency can be dropped when upstream resolves
    # https://github.com/JuliaLang/julia/issues/30154
    depends_on "libunwind"
  end

  fails_with gcc: "5"

  # Fix compatibility with LibGit2 1.2.0+
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

    gcc = Formula["gcc"]
    gcclibdir = gcc.opt_lib/"gcc"/gcc.any_installed_version.major
    if OS.mac?
      deps.map(&:to_formula).select(&:keg_only?).map(&:opt_lib).each do |libdir|
        ENV.append "LDFLAGS", "-Wl,-rpath,#{libdir}"
      end
      ENV.append "LDFLAGS", "-Wl,-rpath,#{gcclibdir}"
      # List these two last, since we want keg-only libraries to be found first
      ENV.append "LDFLAGS", "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"
      ENV.append "LDFLAGS", "-Wl,-rpath,/usr/lib"
    else
      ENV.append "LDFLAGS", "-Wl,-rpath,#{opt_lib}"
      ENV.append "LDFLAGS", "-Wl,-rpath,#{opt_lib}/julia"

      # Help Julia find our libunwind. Remove when upstream replace this with LLVM libunwind.
      (lib/"julia").mkpath
      Formula["libunwind"].opt_lib.glob(shared_library("libunwind", "*")) do |so|
        (buildpath/"usr/lib").install_symlink so
        (lib/"julia").install_symlink so
      end
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
        (lib/"julia").children.each do |so|
          next unless (libdir/so.basename).exist?

          ln_sf (libdir/so.basename).relative_path_from(lib/"julia"), lib/"julia"
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
    assert_equal "4", shell_output("#{bin}/julia -E '2 + 2'").chomp
    system bin/"julia", "-e", 'Base.runtests("core")'

    (lib/"julia").children.each do |so|
      next unless so.symlink?

      assert_predicate so, :exist?, "Broken linkage with #{so.basename}"
    end
  end
end
