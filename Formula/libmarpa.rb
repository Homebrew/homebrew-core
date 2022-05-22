class Libmarpa < Formula
  desc "Marpa parse engine C library -- STABLE"
  homepage "https://jeffreykegler.github.io/Marpa-web-site/libmarpa.html"
  url "https://github.com/jeffreykegler/libmarpa/archive/refs/tags/v8.6.2.tar.gz"
  sha256 "b7eb539143959c406ced4a3afdb56419cc5836e679f4094630697e7dd2b7f55a"
  license "MIT"
  head "https://github.com/jeffreykegler/libmarpa.git", branch: "tested"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "a2a018c3e68558b814af011edfd63e2e436b004ec922f421238069000df676fa"
    sha256 cellar: :any,                 arm64_big_sur:  "a76c00de9a82a60bdd16866d768707b067a234bb02ba3fc697b96bcf4565c186"
    sha256 cellar: :any,                 monterey:       "7689fe94c88bfbad0797889ab2294d3537768135812bbf4babe9292edbd01a6e"
    sha256 cellar: :any,                 big_sur:        "850e548bbacd37de6bc739fc25feab2c2794715bf6d786cb0e8e54c107c5aa4f"
    sha256 cellar: :any,                 catalina:       "78eb4ac45c29dfc3237290d802f2f2cc29c0e17df238877ed2bcdb27f8b9d43e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcfb728a555cedfcf5f88178a45e82be6679a0d52e5afd90fee2641bcef3cd15"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "emacs" => :build
  depends_on "libtool" => :build
  depends_on "texinfo" => :build
  depends_on "texlive" => :build

  def install
    ENV.deparallelize
    inreplace "work/etc/libmarpa.pc.in", "prefix=\".\"", "prefix=\"#{prefix}\"" if build.head?
    system "make", build.head? ? "dist" : "dists"
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
