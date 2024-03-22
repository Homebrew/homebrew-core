class Libmarpa < Formula
  desc "Marpa parse engine C library -- STABLE"
  homepage "https://jeffreykegler.github.io/Marpa-web-site/libmarpa.html"
  url "https://github.com/jeffreykegler/libmarpa/archive/refs/tags/v11.0.13.tar.gz"
  sha256 "cb3c7f47d9ee95de967838ea0ecc380ffacfdfd8ec2c3d7cc2a6acaa4cc9597b"
  license "MIT"
  head "https://github.com/jeffreykegler/libmarpa.git", branch: "tested"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fb4bb4ed2f54fe81cafed6f6a768edf2360cd0cf00f9e78be219848e968e5ebd"
    sha256 cellar: :any,                 arm64_ventura:  "a355e4c22bf6dbc889cfb04bec4051d6c883007effc98812da80e342872c5021"
    sha256 cellar: :any,                 arm64_monterey: "744cec05eae127e97a33db6d051d3f4d46dbadea13490f08038d774580c184ba"
    sha256 cellar: :any,                 sonoma:         "3c91fed9728744bd505e5413ee5207eebef9afd50a0e9e1b194c931280901e24"
    sha256 cellar: :any,                 ventura:        "861da7c3426ab3123f50b7c096862e330884ddfac787573ed73c1333e6b12f86"
    sha256 cellar: :any,                 monterey:       "fc47bf5541ca2ecf4b1f12551d24cba28d54b80e9862d29c3e017a21379e877d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b080d6a68a430f6436b88d04cfd25831f3f984c0131b571646adea928092bce8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "emacs" => :build
  depends_on "libtool" => :build
  depends_on "texinfo" => :build
  depends_on "texlive" => :build

  def install
    ENV.deparallelize
    inreplace "work/etc/libmarpa.pc.in", "prefix=\".\"", "prefix=\"#{prefix}\""
    inreplace "work/ac/Makefile.am", "git log -n 5", "## git log -n 5"
    system "make", "ac_dist"
    mkdir "build" do
      system "../ac_dist/configure", *std_configure_args, "--disable-silent-rules"
      system "make", "install"
      (lib/"pkgconfig").install "libmarpa.pc"
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
