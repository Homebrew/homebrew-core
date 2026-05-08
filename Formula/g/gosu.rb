class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/refs/tags/v1.18.7.tar.gz"
  sha256 "8a0abed3d84409766689e2937c24505f77c1aeff79eb54474fa5d40f8bc991dc"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e1e6a55fb4a416f905b12ec7ee687c05b3a227ab26e342dd7c4767c935c962f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dc01806e53d3daa36a2da7f931f801c9398e10344f3df1c4f17166fd66e12a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2e65d291ff073a9382737bc72de03800e618c66ec766d3ddbb430e0d0d16706"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ebf3bd4f90b1eeb0fd04d3f77dd9ab238970de37419a61398e95fec6aec33d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "778b24d3dbdab179a8d574838cc9028c5b786a9716f5e99eb9d96f15aafc2e65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78271f3a4e1df16086ca5be830c0bebb07f44c632b79319c65c18db85af60141"
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
