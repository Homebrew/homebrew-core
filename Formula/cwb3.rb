class Cwb3 < Formula
  desc "Tools for managing and querying large text corpora with linguistic annotations"
  homepage "https://cwb.sourceforge.io/"
  license "GPL-2.0-or-later"

  stable do
    url "https://downloads.sourceforge.net/project/cwb/cwb/cwb-3.5-RC/cwb-3.4.33-src.tar.gz"
    sha256 "947d5f6d710fd8f818c2dc027e991b898308d581cb9b89c4ce6db054fbb20948"
  end

  head do
    url "svn://svn.code.sf.net/p/cwb/code/cwb/trunk"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "pcre"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  def install
    system("make", "all",
      "PLATFORM=homebrew-formula", "SITE=homebrew-formula", "FULL_MESSAGES=1",
      "PREFIX=#{prefix}", "HOMEBREW_ROOT=#{HOMEBREW_PREFIX}")
    ENV.deparallelize
    system("make", "install",
      "PLATFORM=homebrew-formula", "SITE=homebrew-formula", "FULL_MESSAGES=1",
      "PREFIX=#{prefix}", "HOMEBREW_ROOT=#{HOMEBREW_PREFIX}")
  end

  def post_install
    default_registry = HOMEBREW_PREFIX/"share/cwb/registry"
    default_registry.mkpath # make sure default registry exists
  end

  def caveats
    default_registry = HOMEBREW_PREFIX/"share/cwb/registry"
    <<~STOP
      CWB default registry directory for this build: #{default_registry}
    STOP
  end

  test do
    resource("tutorial_data") do
      url "https://cwb.sourceforge.io/files/encoding_tutorial_data.zip"
      sha256 "bbd37514fdbdfd25133808afec6a11037fb28253e63446a9e548fb437cbdc6f0"
    end

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
      system("#{ENV.cc} -o test `#{bin}/cwb-config -I` test.c `#{bin}/cwb-config -L`")
      assert_equal("3\n", shell_output("./test"),
        "compiled test program works")
    end
  end
end
