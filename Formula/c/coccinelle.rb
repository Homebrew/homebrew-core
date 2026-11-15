class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "https://coccinelle.gitlabpages.inria.fr/website/"
  url "https://coccinelle.gitlabpages.inria.fr/website/distrib/coccinelle-1.3.3.tar.gz"
  sha256 "265dba12a71e5169d49af9a2d8c3c4b8e2cae4c451c918beb2587c33d6128e3d"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/coccinelle/coccinelle.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "bc4091065073104e372453f2d3b93f08f16b3dc59d82b9c3e78c2f1f0c8d715a"
    sha256 arm64_tahoe:       "a0fc5050367daafa8362c6b8434eb1b0b490c8290085fed933038c8e0eb951a9"
    sha256 arm64_sequoia:     "3cf6eb126e96365566672131345ae9e788511ab43dc42cc9f11059a61a63440a"
    sha256 arm64_linux:       "a2ba0c0d3a73e74d7767fff726667edf15ea66aa3300d487478325074d8c1f7c"
    sha256 x86_64_linux:      "d9fa5fa1c87f8c664afc7b42e7775f7b9fdeddc38b7285d713ed134a2548fc65"
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

  deny_network_access!

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
