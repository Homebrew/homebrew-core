class Libmarpa < Formula
  desc "Marpa parse engine C library -- STABLE"
  homepage "https://jeffreykegler.github.io/Marpa-web-site/libmarpa.html"
  url "https://github.com/jeffreykegler/libmarpa/archive/refs/tags/v8.6.2.tar.gz", using: :nounzip
  sha256 "b7eb539143959c406ced4a3afdb56419cc5836e679f4094630697e7dd2b7f55a"
  license "MIT"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "texlive" => :build

  uses_from_macos "texinfo" => :build

  def install
    ENV.deparallelize
    system "tar", "-xzf", "libmarpa-" + version.to_s + ".tar.gz"
    chdir "libmarpa-#{version}" do
      system "make", "dists"
    end
    mkdir "build" do
      system "cmake", "../libmarpa-" + version.to_s + "/cm_dist", *std_cmake_args, "--install-prefix", prefix.to_s
      system "cmake", "--build", "."
      system "cmake", "--install", "."
      File.rename prefix.to_s + "/inc", include.to_s
    end
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
