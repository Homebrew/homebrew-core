class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "https://coccinelle.gitlabpages.inria.fr/website/"
  url "https://coccinelle.gitlabpages.inria.fr/website/distrib/coccinelle-1.3.1.tar.gz"
  sha256 "f76ddd4fbe41019af6ed1986121523f0a0498aaf193e19fb2d7ab0b7cdf8eb46"
  license "GPL-2.0-only"
  head "https://github.com/coccinelle/coccinelle.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "68d31e6e796053a1990fd57125cfe3698d42cde6f7d86881ad94cf0c08d63692"
    sha256 arm64_sequoia: "955dd52ff552b0758e7c943eb94dbbb9bb59bb7c258d7cf9e8fd6c8c8dffb56a"
    sha256 arm64_sonoma:  "5333d358275ab1578b2cdaecc1ba0fd319f8674a5d3fa884d8e5c4617e67b30f"
    sha256 sonoma:        "e4f41aeb38cad12db61935111361b68bd4d45c506f8c9ce70aa419a328f2750d"
    sha256 arm64_linux:   "81caea3577c51cd4675f8a083bd2c3f11da58e480b3bec32a20b3031d3ae72c2"
    sha256 x86_64_linux:  "ffbdeba6cd8f0f65c86c7d48b0fe13f4a27c1c9ba62895570d49683085abb773"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "menhir" => :build
  depends_on "ocaml" => :build
  depends_on "ocaml-findlib" => :build

  # Apply Fedora patch to allow stdcompat to build with ocaml 5.4.0.
  # When removing patch, also remove autoreconf and make autoconf/automake HEAD-only.
  # Issue ref: https://github.com/ocamllibs/stdcompat/issues/62
  patch do
    url "https://src.fedoraproject.org/rpms/ocaml-stdcompat/raw/2f4345ccea8eda0cd2a4cc33c337a9d92d66eb3c/f/ocaml-stdcompat-ocaml5.4.patch"
    sha256 "f30c8c3d75f9486020c47cf7d1701917e18497c92956b3c11cea79adbbeb7689"
    directory "bundles/stdcompat/stdcompat-current"
  end

  def install
    # Remove unused bundled libraries
    rm_r(["bundles/menhirLib", "bundles/pcre"])

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
