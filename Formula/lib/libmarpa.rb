class Libmarpa < Formula
  desc "Marpa parse engine C library -- STABLE"
  homepage "https://jeffreykegler.github.io/Marpa-web-site/libmarpa.html"
  url "https://github.com/jeffreykegler/libmarpa/archive/refs/tags/v9.0.3.tar.gz"
  sha256 "2fd21d7ae0c05743a0503cd52467f33beff72c555b0b10283e2c761464496f21"
  license "MIT"
  head "https://github.com/jeffreykegler/libmarpa.git", branch: "tested"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d8990e68cdbf7e72eabee1a7b07813fb1d9c7342ab7429ef17c96cdd007a5489"
    sha256 cellar: :any,                 arm64_ventura:  "9c44b6ac4750d7c0c22928c3ed71b177149bc04f9b0eb1d81f1e4a0a44f20d93"
    sha256 cellar: :any,                 arm64_monterey: "3b1f23479cc0c9be0394de78dcd2c6f45958f0dd4537766e8620baf12b9e52e9"
    sha256 cellar: :any,                 arm64_big_sur:  "3ef4f6ceface8cd5589bed2074d6a2f90853e0f1a6e04bddcf3fee3f7d282b95"
    sha256 cellar: :any,                 sonoma:         "638ee3848ae1395f7b3447634f3e7b2c6a89afc329aa3ec90eb70d5dc7001372"
    sha256 cellar: :any,                 ventura:        "291cbe0cc4cca93255535ae8f3cca6ecc825b6ddb3ff8428644904c76b80bcc3"
    sha256 cellar: :any,                 monterey:       "d989c55363840d93279540952280d095ffdd370f421564b58971784152de3619"
    sha256 cellar: :any,                 big_sur:        "ad0ccc298e941b7a668af5355e2955f1be470a48a38c4aced5ee6fae1e172902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c0bfd36ca2460b291dbfbbfbb93fcc8694e069cc514eb7953f6bf7ba012e8e6"
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
    inreplace "work/etc/libmarpa.pc.in", "prefix=\".\"", "prefix=\"#{prefix}\""
    inreplace "work/ac/Makefile.am", "git log -n 5", "## git log -n 5"
    system "make", "dist"
    system "cmake", "-S", "cm_dist", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
