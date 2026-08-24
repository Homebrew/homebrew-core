class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "https://coccinelle.gitlabpages.inria.fr/website/"
  url "https://coccinelle.gitlabpages.inria.fr/website/distrib/coccinelle-1.3.2.tar.gz"
  sha256 "84c1b62af85e69b8e7100f54d19a21d090300d5e5e790953eb6b1e2c4d6edf0c"
  license "GPL-2.0-only"
  head "https://github.com/coccinelle/coccinelle.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "edb6f6df18f0c6f10a371faff20f82e05c398a486b54db25ce7043f53a4371a1"
    sha256 arm64_sequoia: "2bce6497965536ec92c7cda4c3ebfe952bc05801a34507c1383e35266caa2bc6"
    sha256 arm64_sonoma:  "7c46f64bacc0c8aadaa9d0b292189940d9983e24b59cb25f64c8d08eb4fd3a69"
    sha256 sonoma:        "e1057a6bb9e80e2bfbb3c4ecc8120fba1ee31bbfa38ddea5ecb82c5d6001ac95"
    sha256 arm64_linux:   "5728741879689e91268978b6cf7d137cfcf12a13e79110abfbd808d1c7d508db"
    sha256 x86_64_linux:  "ba4473fb40732f336210c0a9617768b5183a11676729e5f9839565d862b9bcac"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "menhir" => :build
  depends_on "ocaml" => :build
  depends_on "ocaml-findlib" => :build

  # Apply Fedora patch to allow stdcompat to build with ocaml 5.5.0.
  # When removing patch, also remove autoreconf and make autoconf/automake HEAD-only.
  patch do
    url "https://src.fedoraproject.org/rpms/ocaml-stdcompat/raw/03dbbd7cb60f48ac7785d15ed995a90734538a5c/f/ocaml-stdcompat-ocaml5.5.patch"
    sha256 "ba7970304d73ebe4d1e4c3f6589274c5f604a6124aa312740c8ccf56c7272bd2"
    directory "bundles/stdcompat/stdcompat-current"
    type :unofficial
    resolves "https://github.com/ocamllibs/stdcompat/pull/75"
  end

  def install
    # Remove unused bundled libraries
    rm_r(["bundles/menhirLib", "bundles/pcre2"])

    # Help find built libraries on macOS
    inreplace "bundles/pyml/Makefile", " LD_LIBRARY_PATH=", " DYLD_LIBRARY_PATH=" if OS.mac?

    # TODO: remove when patch is no longer needed
    cd "bundles/stdcompat/stdcompat-current" do
      system "autoreconf", "--force", "--install", "--verbose"
    end

    system "./autogen" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--disable-pcre-syntax", # needs EOL `pcre`
                          "--enable-ocaml",
                          "--enable-opt",
                          "--with-bash-completion=#{bash_completion}",
                          "--with-python=python3",
                          "--without-pdflatex",
                          *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"

    pkgshare.install "demos/simple.cocci", "demos/simple.c"
  end

  test do
    system bin/"spatch", "-sp_file", "#{pkgshare}/simple.cocci", "#{pkgshare}/simple.c", "-o", "new_simple.c"
    expected = <<~C
      int main(int i) {
        f("ca va", 3);
        f(g("ca va pas"), 3);
      }
    C

    assert_equal expected, (testpath/"new_simple.c").read
  end
end
