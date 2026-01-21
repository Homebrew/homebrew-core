class Cwb3 < Formula
  desc "Tools for managing and querying large text corpora with linguistic annotations"
  homepage "https://cwb.sourceforge.io/"
  license "GPL-2.0-or-later"
  head "svn://svn.code.sf.net/p/cwb/code/cwb/trunk"

  stable do
    url "https://downloads.sourceforge.net/project/cwb/cwb/cwb-3.5/source/cwb-3.5.0-src.tar.gz"
    sha256 "20bbd00b7c830389ce384fe70124bc0f55ea7f3d70afc3a159e6530d51b24059"

    # Backport support for PCRE2 to help with EOL `pcre` deprecation
    # https://sourceforge.net/p/cwb/code/1831/
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/071dacd02a9613204ca265eeb18fe74a1a838329/Patches/cwb3/r1831.diff"
      sha256 "b20d91efc9eb7bc515880ba9a29f49c553615cc9ab1cfbc6d09638ad677de4a7"
    end
  end

  livecheck do
    url "https://sourceforge.net/projects/cwb/rss?path=/cwb"
    regex(%r{url=.*?/cwb[._-]v?(\d+(?:\.\d+)+)-src\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "29bea0c252b17882c4f5b6bd3dbc8f754ba28f49b65ea07b2635ee9b8f1d8723"
    sha256 cellar: :any,                 arm64_sequoia: "2633ae43e4b9cdb574706bd8c95ca5748ba182388cd570dce3b96bf05503e220"
    sha256 cellar: :any,                 arm64_sonoma:  "3ac7b013866746a8a820daa9e60b50f4c49687a1e827820fd498437d99142d7b"
    sha256 cellar: :any,                 sonoma:        "647782abbc558ce33f2ba5f8395c87f1766a97f29f1579e4e4a90e68ee726b95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bd38dd9f85b5bf1fea476b21c524d2c7ccd4cdac339f455f3b971516d0ea255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c67cd104f2291f73ba6785c1a023c39677e7132dbb23673fed7729a73aebb669"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "pcre2"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  resource("tutorial_data") do
    url "https://cwb.sourceforge.io/files/encoding_tutorial_data.zip"
    sha256 "bbd37514fdbdfd25133808afec6a11037fb28253e63446a9e548fb437cbdc6f0"
  end

  def install
    args = %W[
      PLATFORM=homebrew-formula
      SITE=homebrew-formula
      FULL_MESSAGES=1
      PREFIX=#{prefix}
      HOMEBREW_ROOT=#{HOMEBREW_PREFIX}
    ]

    system "make", "all", *args
    ENV.deparallelize
    system "make", "install", *args

    # Avoid rebuilds when dependencies are bumped.
    inreplace bin/"cwb-config" do |s|
      s.gsub! Formula["glib"].prefix.realpath, Formula["glib"].opt_prefix
      s.gsub! Formula["pcre2"].prefix.realpath, Formula["pcre2"].opt_prefix
    end
  end

  def default_registry
    HOMEBREW_PREFIX/"share/cwb/registry"
  end

  def post_install
    # make sure default registry exists
    default_registry.mkpath
  end

  def caveats
    <<~STOP
      CWB default registry directory: #{default_registry}
    STOP
  end

  test do
    resource("tutorial_data").stage do
      Pathname("registry").mkdir
      Pathname("data").mkdir

      system(bin/"cwb-encode", "-c", "ascii",
        "-d", "data", "-R", "registry/ex", "-f", "example.vrt",
        "-P", "pos", "-P", "lemma", "-S", "s:0")
      assert_path_exists Pathname("registry")/"ex", "registry file has been created"
      assert_path_exists Pathname("data")/"lemma.lexicon", "lexicon file for p-attribute lemma has been created"

      system(bin/"cwb-makeall", "-r", "registry", "EX")
      assert_path_exists Pathname("data")/"lemma.corpus.rev",
"reverse index file for p-attribute lemma has been created"

      assert_equal("Tokens:\t5\nTypes:\t5\n",
        shell_output("#{bin}/cwb-lexdecode -r registry -S EX"),
        "correct token & type count for p-attribute")
      assert_equal("0\t4\n",
        shell_output("#{bin}/cwb-s-decode -r registry EX -S s"),
        "correct span for s-attribute")

      assert_equal("3\n",
        shell_output("#{bin}/cqpcl -r registry -D EX 'A=[pos = \"\\w{2}\"]; size A;'"),
        "CQP query works correctly")

      Pathname("test.c").write <<~C
        #include <stdlib.h>
        #include <cwb/cl.h>

        int main(int argc, char *argv[]) {
          int *id, n_id, n_token;
          Corpus *C = cl_new_corpus("registry", "ex");
          Attribute *word = cl_new_attribute(C, "word", ATT_POS);
          id = cl_regex2id(word, "\\\\p{Ll}+", 0, &n_id);
          if (n_id > 0)
            n_token = cl_idlist2freq(word, id, n_id);
          else
            n_token = 0;
          printf("%d\\n", n_token);
          return 0;
        }
      C
      cppflags = Utils.safe_popen_read("#{bin}/cwb-config", "-I").strip.split
      ldflags = Utils.safe_popen_read("#{bin}/cwb-config", "-L").strip.split
      system ENV.cc, "-o", "test", *cppflags, "test.c", *ldflags
      assert_equal("3\n", shell_output("./test"),
        "compiled test program works")
    end
  end
end
