class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  url "https://www.dynare.org/release/source/dynare-6.1.tar.xz"
  sha256 "fe887a570d13c1ae2fb45fb2978eee59cdf0f3915120fdde5bc3614e584d0693"
  license "GPL-3.0-or-later"
  revision 1
  head "https://git.dynare.org/Dynare/dynare.git", branch: "master"

  livecheck do
    url "https://www.dynare.org/download/"
    regex(/href=.*?dynare[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "4381ab59be83bc0878d07d8a3c6ca29a77748d5e70eb01165546ee2f78d37b4e"
    sha256 cellar: :any, arm64_ventura:  "047a5f54a033673fee6a33d23d9245ba65f998a010e64522ea5d0d8d9aa2d9f0"
    sha256 cellar: :any, arm64_monterey: "41331f1a575227b51018d210493744903ae0cbbd40369ba7c414f65b62778a0f"
    sha256 cellar: :any, sonoma:         "8c4afc60b4f4a4653da5b0fea37310cd85c68cf0e2d127e9ed7f610b59c112a3"
    sha256 cellar: :any, ventura:        "50d033bacb8fd97073ff242c35ca5339a16d5d11f727d43497c7390e975b482c"
    sha256 cellar: :any, monterey:       "4129eb268eaeb010e1156bd5152f1f87a7e87d2950bde471382a271ff4ad41a3"
    sha256               x86_64_linux:   "31d38c3fdfef6d9919bfd856f230718b456fb38c8260e5aec624fd6886a0066f"
  end

  depends_on "bison" => :build
  depends_on "boost" => :build
  depends_on "cweb" => :build
  depends_on "flex" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "gcc"
  depends_on "gsl"
  depends_on "hdf5"
  depends_on "libmatio"
  depends_on "metis"
  depends_on "octave"
  depends_on "openblas"
  depends_on "suite-sparse"

  fails_with :clang do
    cause <<~EOS
      GCC is the only compiler supported by upstream
      https://git.dynare.org/Dynare/dynare/-/blob/master/README.md#general-instructions
    EOS
  end

  resource "slicot" do
    url "https://deb.debian.org/debian/pool/main/s/slicot/slicot_5.0+20101122.orig.tar.gz"
    sha256 "fa80f7c75dab6bfaca93c3b374c774fd87876f34fba969af9133eeaea5f39a3d"
  end

  def install
    resource("slicot").stage do
      system "make", "lib", "OPTS=-fPIC", "SLICOTLIB=../libslicot_pic.a",
             "FORTRAN=gfortran", "LOADER=gfortran"
      system "make", "clean"
      system "make", "lib", "OPTS=-fPIC -fdefault-integer-8",
             "FORTRAN=gfortran", "LOADER=gfortran",
             "SLICOTLIB=../libslicot64_pic.a"
      (buildpath/"slicot/lib").install "libslicot_pic.a", "libslicot64_pic.a"
    end

    # Work around used in upstream builds which helps avoid runtime preprocessor error.
    # https://git.dynare.org/Dynare/dynare/-/blob/master/macOS/homebrew-native-arm64.ini
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    # Help meson find `suite-sparse` and `slicot`
    ENV.append_path "LIBRARY_PATH", Formula["suite-sparse"].opt_lib
    ENV.append_path "LIBRARY_PATH", buildpath/"slicot/lib"

    system "meson", "setup", "build", "-Dbuild_for=octave", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    (pkgshare/"examples").install "examples/bkk.mod"
  end

  def caveats
    <<~EOS
      To get started with Dynare, open Octave and type
        addpath #{opt_lib}/dynare/matlab
    EOS
  end

  test do
    resource "statistics" do
      url "https://github.com/gnu-octave/statistics/archive/refs/tags/release-1.6.5.tar.gz", using: :nounzip
      sha256 "0ea8258c92ce67e1bb75a9813b7ceb56fff1dacf6c47236d3da776e27b684cee"
    end

    ENV.cxx11
    ENV.delete "LDFLAGS" # avoid overriding Octave flags

    # Work around Xcode 15.0 ld error with GCC: https://github.com/Homebrew/homebrew-core/issues/145991
    if OS.mac? && (MacOS::Xcode.version.to_s.start_with?("15.0") || MacOS::CLT.version.to_s.start_with?("15.0"))
      ENV["LDFLAGS"] = shell_output("#{Formula["octave"].opt_bin}/mkoctfile --print LDFLAGS").chomp
      ENV.append "LDFLAGS", "-Wl,-ld_classic"
    end

    statistics = resource("statistics")
    testpath.install statistics

    cp pkgshare/"examples/bkk.mod", testpath

    # Replace `makeinfo` with dummy command `true` to prevent generating docs
    # that are not useful to the test.
    (testpath/"dyn_test.m").write <<~EOS
      makeinfo_program true
      pkg prefix #{testpath}/octave
      pkg install statistics-release-#{statistics.version}.tar.gz
      dynare bkk.mod console
    EOS

    system Formula["octave"].opt_bin/"octave", "--no-gui",
           "--no-history", "--path", "#{lib}/dynare/matlab", "dyn_test.m"
  end
end
