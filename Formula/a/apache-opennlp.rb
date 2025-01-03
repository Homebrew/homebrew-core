class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=opennlp/opennlp-2.5.2/apache-opennlp-2.5.2-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-2.5.2/apache-opennlp-2.5.2-bin.tar.gz"
  sha256 "d515781b1444038dad6433ee8414f535bac3b244f126b3b5479a5b021bf22246"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6af9c46ca1928c9e35c8797e91e2fb853549a982447902642fec5ee99975fa9d"
  end

  depends_on "openjdk"

  # build patch to remove quote for `$HEAP`, upstream pr ref, https://github.com/apache/opennlp/pull/734
  patch :DATA

  def install
    # Remove Windows scripts
    rm(Dir["bin/*.bat"])

    libexec.install Dir["*"]
    (bin/"opennlp").write_env_script libexec/"bin/opennlp", JAVA_HOME:    Formula["openjdk"].opt_prefix,
                                                            OPENNLP_HOME: libexec
  end

  test do
    output = pipe_output("#{bin}/opennlp SimpleTokenizer", "Hello, friends", 0)
    assert_equal "Hello , friends", output.lines.first.chomp
  end
end

__END__
diff --git a/bin/opennlp b/bin/opennlp
index 8375e2d..c1c2984 100755
--- a/bin/opennlp
+++ b/bin/opennlp
@@ -58,4 +58,4 @@ if [ -n "$JAVA_HEAP" ] ; then
   HEAP="-Xmx$JAVA_HEAP"
 fi

-$JAVACMD "$HEAP" -Dlog4j.configurationFile="$OPENNLP_HOME/conf/log4j2.xml" -cp "$CLASSPATH" opennlp.tools.cmdline.CLI "$@"
+$JAVACMD $HEAP -Dlog4j.configurationFile="$OPENNLP_HOME/conf/log4j2.xml" -cp "$CLASSPATH" opennlp.tools.cmdline.CLI "$@"
