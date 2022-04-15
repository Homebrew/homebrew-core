class Libmarpa < Formula
  desc "Marpa parse engine C library -- STABLE"
  homepage "https://jeffreykegler.github.io/Marpa-web-site/libmarpa.html"
  url "https://github.com/jeffreykegler/libmarpa/archive/refs/tags/v8.6.2.tar.gz"
  sha256 "b7eb539143959c406ced4a3afdb56419cc5836e679f4094630697e7dd2b7f55a"
  license "MIT"
  head "https://github.com/jeffreykegler/libmarpa.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "140c12d4c31564e6be52416703b42d2625873d9c2cc9c25abeb87c77d2dc38b5"
    sha256 cellar: :any,                 arm64_big_sur:  "73e473c2f18ba649fdd2e830ea23fce50cb090af3d9347cee98c696ba6a56dc3"
    sha256 cellar: :any,                 monterey:       "47debd91bf8dc1396c5d6b56ae4bef892ee5bd95b3c8196846b8ae42ad4a03dd"
    sha256 cellar: :any,                 big_sur:        "42576c639034eb246286ff198912e441cdf45fbed556bf953ca4b658aa90f69d"
    sha256 cellar: :any,                 catalina:       "52940241416f5a6434a8fa155903945c9d592623f84663287d78d7a4221a8441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0b869d0ef1c1b0c3d0152c45fb33e31c3c820c0b45e4d94a106487ac6840d76"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "texlive" => :build

  uses_from_macos "texinfo" => :build

  def install
    ENV.deparallelize
    system "make", "dists"
    system "cmake", "-S", "cm_dist", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    include.install (prefix/"inc").children unless build.head?
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <marpa.h>
      int main(void)
      {
        Marpa_Config marpa_configuration;
        Marpa_Grammar g;
        marpa_c_init (&marpa_configuration);
        g = marpa_g_new (&marpa_configuration);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lmarpa", "-o", "test"
    system "./test"
  end
end
