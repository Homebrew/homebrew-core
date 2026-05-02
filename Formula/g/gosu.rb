class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/refs/tags/v1.18.7.tar.gz"
  sha256 "8a0abed3d84409766689e2937c24505f77c1aeff79eb54474fa5d40f8bc991dc"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a9fbc740652f079d012dc919d88e82144a1cd3eea461b4568dbbe91aa5b4aa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "832bb0b6f774304d98fc6742bdb63da9eb4d85aa93693604cb23904885583604"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f47030e23755e85a979adc972a2665889fc52f627294c95ba123a9f3549c7c99"
    sha256 cellar: :any_skip_relocation, sonoma:        "917a9ae63584e4762ee76fdf7fb35c1ed0ce0342a39a96f6ed32617093f868d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8ff5d1b2c5b5df671572bb9addf121151ccebbf2562f1a622c016c4b12595a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "277eb63cbd485e59653c4d04a8acda5b734add1ea2a3792692226fd09f425d35"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  skip_clean "libexec/ext"

  # Drop gosu-doc (javadoc internals don't compile on JDK 17+) and uncomment
  # JDK 13+ TreeVisitor stubs upstream left disabled.
  patch :DATA

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")

    system "mvn", "package"
    libexec.install Dir["gosu/target/gosu-#{version}-full/gosu-#{version}/*"]
    (libexec/"ext").mkpath
    (bin/"gosu").write_env_script libexec/"bin/gosu", Language::Java.java_home_env("17")
  end

  test do
    (testpath/"test.gsp").write 'print ("burp")'
    assert_equal "burp", shell_output("#{bin}/gosu test.gsp").chomp
  end
end

__END__
--- a/pom.xml
+++ b/pom.xml
@@ -25,7 +25,6 @@
     <module>gosu-core-api-precompiled</module>
     <module>gosu-process</module>
     <module>gosu-lab</module>
-    <module>gosu-doc</module>
     <module>gosu-maven-compiler</module>
     <module>gosu-parent</module>
     <module>gosu-test</module>
--- a/gosu/pom.xml
+++ b/gosu/pom.xml
@@ -35,12 +35,6 @@
       <version>${project.version}</version>
       <scope>runtime</scope>
     </dependency>
-    <dependency>
-      <groupId>org.gosu-lang.gosu</groupId>
-      <artifactId>gosu-doc</artifactId>
-      <version>${project.version}</version>
-      <scope>runtime</scope>
-    </dependency>
   </dependencies>

   <build>
--- a/gosu-lab/src/main/java/editor/util/transform/java/visitor/GosuVisitor.java
+++ b/gosu-lab/src/main/java/editor/util/transform/java/visitor/GosuVisitor.java
@@ -2210,35 +2210,35 @@

   // Overrides for visitors new in Java 17...

-//  public String visitBindingPattern( BindingPatternTree node, Object o )
-//  {
-//    return null;
-//  }
+  public String visitBindingPattern( BindingPatternTree node, Object o )
+  {
+    return null;
+  }
 //
-//  public String visitDefaultCaseLabel( DefaultCaseLabelTree node, Object o )
-//  {
-//    return null;
-//  }
+  public String visitDefaultCaseLabel( DefaultCaseLabelTree node, Object o )
+  {
+    return null;
+  }
 //
-//  public String visitGuardedPattern( GuardedPatternTree node, Object o )
-//  {
-//    return null;
-//  }
-//
-//  public String visitParenthesizedPattern( ParenthesizedPatternTree node, Object o )
-//  {
-//    return null;
-//  }
+  public String visitGuardedPattern( GuardedPatternTree node, Object o )
+  {
+    return null;
+  }
 //
-//  public String visitSwitchExpression( SwitchExpressionTree node, Object o )
-//  {
-//    return null;
-//  }
+  public String visitParenthesizedPattern( ParenthesizedPatternTree node, Object o )
+  {
+    return null;
+  }
 //
-//  public String visitYield( YieldTree node, Object o )
-//  {
-//    return null;
-//  }
+  public String visitSwitchExpression( SwitchExpressionTree node, Object o )
+  {
+    return null;
+  }
+//
+  public String visitYield( YieldTree node, Object o )
+  {
+    return null;
+  }

   private void pushIndent()
   {
