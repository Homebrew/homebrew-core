class Cwb3 < Formula
  desc "Tools for managing and querying large text corpora with linguistic annotations"
  homepage "https://cwb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cwb/cwb/cwb-3.5/source/cwb-3.5.0-src.tar.gz"
  sha256 "20bbd00b7c830389ce384fe70124bc0f55ea7f3d70afc3a159e6530d51b24059"
  license "GPL-2.0-or-later"
  head "svn://svn.code.sf.net/p/cwb/code/cwb/trunk"

  livecheck do
    url "https://sourceforge.net/projects/cwb/rss?path=/cwb"
    regex(%r{url=.*?/cwb[._-]v?(\d+(?:\.\d+)+)-src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "933ced8d74d9a2be889a4c0b65f19df7730c3ef071fd15e5b143183a929c0ce1"
    sha256 cellar: :any,                 arm64_monterey: "0095bcb1957680c0111d0350bb709ea9c5944eb0375654ef76b7d9f455fbc531"
    sha256 cellar: :any,                 arm64_big_sur:  "1cd5c987e8f41b62244439ba320bb77f92b7bfbb528d31b75726071ad9822a58"
    sha256 cellar: :any,                 ventura:        "bb8314de701f695b87f82eb7b8377268ca56a333e05895b607c081ba8f6f45ad"
    sha256 cellar: :any,                 monterey:       "9271d4472d3ce7e71c65755e33ba8d303edcc603ce7e493c12d6c870a7f84f0f"
    sha256 cellar: :any,                 big_sur:        "af3c7316e0a0678d7cf11d151c109cbbd0f36b9df36c9b1d2c210ce6654e6030"
    sha256 cellar: :any,                 catalina:       "a15fdf57dceb390674290d8a1aaabdf93385b60a675de29a0af5219d85116d95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36c736d9eee76fc6c3db520901f42677e8dfc1ea390b319264c4e0d75b612ccc"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "pcre"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

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
      s.gsub! Formula["pcre"].prefix.realpath, Formula["pcre"].opt_prefix
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
      assert_predicate(Pathname("registry")/"ex", :exist?,
        "registry file has been created")
      assert_predicate(Pathname("data")/"lemma.lexicon", :exist?,
        "lexicon file for p-attribute lemma has been created")

      system(bin/"cwb-makeall", "-r", "registry", "EX")
      assert_predicate(Pathname("data")/"lemma.corpus.rev", :exist?,
        "reverse index file for p-attribute lemma has been created")

      assert_equal("Tokens:\t5\nTypes:\t5\n",
        shell_output("#{bin}/cwb-lexdecode -r registry -S EX"),
        "correct token & type count for p-attribute")
      assert_equal("0\t4\n",
        shell_output("#{bin}/cwb-s-decode -r registry EX -S s"),
        "correct span for s-attribute")

      assert_equal("3\n",
        shell_output("#{bin}/cqpcl -r registry -D EX 'A=[pos = \"\\w{2}\"]; size A;'"),
        "CQP query works correctly")

      Pathname("test.c").write <<~STOP
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
      STOP
      cppflags = Utils.safe_popen_read("#{bin}/cwb-config", "-I").strip.split
      ldflags = Utils.safe_popen_read("#{bin}/cwb-config", "-L").strip.split
      system ENV.cc, "-o", "test", *cppflags, "test.c", *ldflags
      assert_equal("3\n", shell_output("./test"),
        "compiled test program works")
    end
  end
end
