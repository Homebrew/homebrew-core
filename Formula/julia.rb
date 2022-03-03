class Julia < Formula
  desc "Fast, Dynamic Programming Language"
  homepage "https://julialang.org/"
  license all_of: ["MIT", "BSD-3-Clause", "Apache-2.0", "BSL-1.0"]
  revision 3
  head "https://github.com/JuliaLang/julia.git", branch: "master"

  stable do
    url "https://github.com/JuliaLang/julia/releases/download/v1.7.1/julia-1.7.1.tar.gz"
    sha256 "17d298e50e4e3dd897246ccebd9f40ce5b89077fa36217860efaec4576aa718e"

    # Patches for compatibility with LLVM 13
    patch do
      url "https://github.com/JuliaLang/julia/commit/677ce6d3adc2f70886f72795b0e5c739e75730ee.patch?full_index=1"
      sha256 "ebcedfbc61b6cc77c0dd9aebb9f1dfa477326241bf5a54209533e4886aad5af3"
    end

    patch do
      url "https://github.com/JuliaLang/julia/commit/47f9139e88917813cb7beee5e690c48c2ac65de4.patch?full_index=1"
      sha256 "cdc41494b2a163ca363da8ea9bcf27d7541a6dc9e6b4eff72f6c8ff8ce1b67b6"
    end

    patch do
      url "https://github.com/JuliaLang/julia/commit/1eb063f1957b2e287ad0c7435debc72af58bb6f1.patch?full_index=1"
      sha256 "d95b9fb5f327bc3ac351c35317a776ef6a46c1cdff248562e70c76e58eb9a903"
    end

    # Backported from:
    # https://github.com/JuliaLang/julia/commit/f8c918b00f7c62e204d324a827e2ee2ef05bb66a
    patch do
      url "https://raw.githubusercontent.com/archlinux/svntogit-community/074e62e4e946201779d2d6df9a261c91d111720f/trunk/f8c918b0.patch"
      sha256 "bc6c85cbbca489ef0b2876dbeb6ae493c11573e058507b8bcb9e01273bc3a38c"
    end

    # Backported from:
    # https://github.com/JuliaLang/julia/commit/6330398088e235e4d4fdbda38c41c87e02384edb.patch
    patch do
      url "https://raw.githubusercontent.com/archlinux/svntogit-community/df73abb8162e31e6541d2143d1db5f9f1d70b632/trunk/63303980.patch"
      sha256 "ce9cd140c3bc39987d60340bf365d6238e79cf4d5385494272c49c64af22ef78"
    end
  end

  bottle do
    sha256 cellar: :any,                 monterey:     "02a3cab3be44f67db2e743a61a6460069e331bc5f035c135e0ff18bf19b8a658"
    sha256 cellar: :any,                 big_sur:      "20c70393419e6bd22f8633ede0f0921b5cec93b126d3cd2c485a32475a18e043"
    sha256 cellar: :any,                 catalina:     "d215242a25cba0c5d467ee88e93ea334675c492bb21127194596bd39381a25c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1cb20f828a0badb49a98cc42439ff8c3729ec95db039b88e3c0c0e08bcb03e50"
  end

  # Requires the M1 fork of GCC to build
  # https://github.com/JuliaLang/julia/issues/36617
  depends_on arch: :x86_64
  depends_on "ca-certificates"
  depends_on "curl"
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "libgit2"
  depends_on "libnghttp2"
  depends_on "libssh2"
  depends_on "llvm"
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

    # This dependency can be dropped when upstream resolves
    # https://github.com/JuliaLang/julia/issues/30154
    depends_on "libunwind"
  end

  conflicts_with "juliaup", because: "both install `julia` binaries"

  fails_with gcc: "5"

  # Fix segfaults with Curl 7.81. We need to patch the contents of a tarball, so this can't be a `patch` block.
  # https://github.com/JuliaLang/Downloads.jl/issues/172
  resource "curl-patch" do
    url "https://raw.githubusercontent.com/archlinux/svntogit-community/6751794c82949589805db950119afba77549554a/trunk/julia-curl-7.81.patch"
    sha256 "710587dd88c7698dc5cdf47a1a50f6f144b584b7d9ffb85fac3f5f79c65fce11"
  end

  # Fix compatibility with LibGit2 1.2.0+
  # https://github.com/JuliaLang/julia/pull/43250
  patch do
    url "https://github.com/JuliaLang/julia/commit/4d7fc8465ed9eb820893235a6ff3d40274b643a7.patch?full_index=1"
    sha256 "3a34a2cd553929c2aee74aba04c8e42ccb896f9d491fb677537cd4bca9ba7caa"
  end

  # Fix compatibility with LibGit2 1.4.0+
  patch do
    url "https://raw.githubusercontent.com/archlinux/svntogit-community/cd813138d8a6fd496d0972a033d55028613be06d/trunk/julia-libgit-1.4.patch"
    sha256 "cfe498a090d0026b92f9db4ed65ac3818c2efa5ec83bcefed728d27abff73081"
  end

  # Remove broken tests running in `test` block. Reported at:
  # https://github.com/JuliaLang/julia/issues/43004
  patch :DATA

  def install
    # Fix segfaults with Curl 7.81. Remove when this is resolved upstream.
    srccache = buildpath/"stdlib/srccache"
    srccache.install resource("curl-patch")

    cd srccache do
      tarball = Pathname.glob("Downloads-*.tar.gz").first
      system "tar", "-xzf", tarball
      extracted_dir = Pathname.glob("JuliaLang-Downloads.jl-*").first
      to_patch = extracted_dir/"src/Curl/Multi.jl"
      system "patch", to_patch, "julia-curl-7.81.patch"
      system "tar", "-czf", tarball, extracted_dir

      md5sum = Digest::MD5.file(tarball).hexdigest
      sha512sum = Digest::SHA512.file(tarball).hexdigest
      (buildpath/"deps/checksums"/tarball/"md5").atomic_write md5sum
      (buildpath/"deps/checksums"/tarball/"sha512").atomic_write sha512sum
    end

    # Build documentation available at
    # https://github.com/JuliaLang/julia/blob/v#{version}/doc/build/build.md
    args = %W[
      VERBOSE=1
      USE_BINARYBUILDER=0
      prefix=#{prefix}
      sysconfdir=#{etc}
      USE_SYSTEM_CSL=1
      USE_SYSTEM_LLVM=1
      USE_SYSTEM_LIBUNWIND=1
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
    args << "TAGGED_RELEASE_BANNER=Built by #{tap.user} (v#{pkg_version})"

    # Prepare directories we install things into for the build
    (buildpath/"usr/lib").mkpath
    (buildpath/"usr/lib/julia").mkpath
    (buildpath/"usr/share/julia").mkpath

    # Help Julia find keg-only dependencies
    deps.map(&:to_formula).select(&:keg_only?).map(&:opt_lib).each do |libdir|
      ENV.append "LDFLAGS", "-Wl,-rpath,#{libdir}"

      next unless OS.linux?

      libdir.glob(shared_library("*")) do |so|
        cp so, buildpath/"usr/lib"
        cp so, buildpath/"usr/lib/julia"
        chmod "u+w", [buildpath/"usr/lib"/so.basename, buildpath/"usr/lib/julia"/so.basename]
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

    # Don't try to use patchelf on our libLLVM.so. This is only present on 1.7.1.
    patchelf = Regexp.escape("$(PATCHELF)")
    shlib_ext = Regexp.escape(".$(SHLIB_EXT)")
    inreplace "Makefile", %r{^\s+#{patchelf} --set-rpath .*/libLLVM#{shlib_ext}$}, "" if OS.linux? && build.stable?

    # Remove library versions from MbedTLS_jll, nghttp2_jll and libLLVM_jll
    # https://git.archlinux.org/svntogit/community.git/tree/trunk/julia-hardcoded-libs.patch?h=packages/julia
    %w[MbedTLS nghttp2 LibGit2 OpenLibm].each do |dep|
      (buildpath/"stdlib").glob("**/#{dep}_jll.jl") do |jll|
        inreplace jll, %r{@rpath/lib(\w+)(\.\d+)*\.dylib}, "@rpath/lib\\1.dylib"
        inreplace jll, /lib(\w+)\.so(\.\d+)*/, "lib\\1.so"
      end
    end
    inreplace (buildpath/"stdlib").glob("**/libLLVM_jll.jl"), /libLLVM-\d+jl\.so/, "libLLVM.so"

    # Make Julia use a CA cert from `ca-certificates`
    cp Formula["ca-certificates"].pkgetc/"cert.pem", buildpath/"usr/share/julia"

    system "make", *args, "install"

    if OS.linux?
      # Replace symlinks referencing Cellar paths with ones using opt paths
      deps.reject(&:build?).map(&:to_formula).map(&:opt_lib).each do |libdir|
        libdir.glob(shared_library("*")) do |so|
          next unless (lib/"julia"/so.basename).exist?

          ln_sf so.relative_path_from(lib/"julia"), lib/"julia"
        end
      end

      libllvm = lib/"julia"/shared_library("libLLVM")
      (lib/"julia").install_symlink libllvm.basename.to_s => libllvm.realpath.basename.to_s
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
    # https://github.com/Homebrew/discussions/discussions/2749
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
                          next true if name.start_with? "sys"
                          next true if name.start_with? "libjulia-internal"
                          next true if name.start_with? "libccalltest"

                          false
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

__END__
diff --git a/test/core.jl b/test/core.jl
index 74edc7c..0d6eaef 100644
--- a/test/core.jl
+++ b/test/core.jl
@@ -3516,9 +3516,6 @@ end
 @test_throws TypeError Union{Int, 1}

 @test_throws ErrorException Vararg{Any,-2}
-@test_throws ErrorException Vararg{Int, N} where N<:T where T
-@test_throws ErrorException Vararg{Int, N} where N<:Integer
-@test_throws ErrorException Vararg{Int, N} where N>:Integer

 mutable struct FooNTuple{N}
     z::Tuple{Integer, Vararg{Int, N}}
