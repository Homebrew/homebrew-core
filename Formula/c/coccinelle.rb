class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "https://coccinelle.gitlabpages.inria.fr/website/"
  url "https://coccinelle.gitlabpages.inria.fr/website/distrib/coccinelle-1.3.3.tar.gz"
  sha256 "265dba12a71e5169d49af9a2d8c3c4b8e2cae4c451c918beb2587c33d6128e3d"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/coccinelle/coccinelle.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "02e5cb9f9591f7710b32e41c7fcd41354f5d051df508f8117ddf9cbfed1b3d86"
    sha256 arm64_tahoe:       "6d937adfd3e8fa099bfa99121f660cd52bd27bbc2636c0e3b353faeac5991be6"
    sha256 arm64_sequoia:     "80ef68b7214208f4a06e2beaf9940782491527c7be6453417d3f7f9214a354b4"
    sha256 arm64_linux:       "eaa8903c1a40cd7c5e952c6c6c5186e60f194b7dc1daf542e046da857911fc4a"
    sha256 x86_64_linux:      "33bb07fc0247f451303222ff04e8cbfa7870d700393d5a8022cb2ca19359543d"
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
