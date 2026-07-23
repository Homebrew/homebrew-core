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
      file "Patches/cwb3/r1831.diff"
    end
  end

  livecheck do
    url "https://sourceforge.net/projects/cwb/rss?path=/cwb"
    regex(%r{url=.*?/cwb[._-]v?(\d+(?:\.\d+)+)-src\.t}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "83bb0c489a53d017c4ed20aac40dc6b02eef4315211bc391fa0be982ca7e0575"
    sha256 cellar: :any, arm64_sequoia: "1f2794123aaf9ba47ae274a2e1f15c8d026cf36c73b6db8a9f38cdd20278fdb7"
    sha256 cellar: :any, arm64_sonoma:  "f166a6610937476512354e391fdbb5b1ad3c80f18e39a7c4a9de11a6878afe2f"
    sha256 cellar: :any, sonoma:        "243e7983c86e88d74881ba0200982892d2736757ea9a7e834f03cbaf7ac55ae8"
    sha256 cellar: :any, arm64_linux:   "80833ab422207dc1b15be8575bb32b17eba9af9bf5fd2d6087e5302fcac7ab54"
    sha256 cellar: :any, x86_64_linux:  "1fe243d8ba65dff4a36a8064c9a97b98ba17fe0215a1245d311ef7bbc45c5f39"
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
      s.gsub! Formula["glib"].prefix.realpath, formula_opt_prefix("glib")
      s.gsub! Formula["pcre2"].prefix.realpath, formula_opt_prefix("pcre2")
    end
  end

  post_install_steps do
    # make sure default registry exists
    mkdir_p "share/cwb/registry", base: :homebrew_prefix
  end

  def caveats
    "CWB default registry directory: #{HOMEBREW_PREFIX}/share/cwb/registry"
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
