class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  # Temporarily using tarball to patch in compatibility with graphviz 3+.
  # TODO: Switch back to official Jar url when issue is fixed.
  url "https://downloads.sourceforge.net/project/plantuml/1.2022.2/plantuml-1.2022.2.tar.gz"
  sha256 "f99dd7d35c2aa57e119c78ebb76ca80b5adf229c7a5a46166bac16cb6e550e63"
  license "GPL-3.0-or-later"
  revision 1
  version_scheme 1

  livecheck do
    url :stable
    regex(%r{url=.*?/plantuml[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e55169886ad5305d0d88334802e6096801e1876cff7084df6270464043489746"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab40c04370a035d4e54710121b88e517ef3182396bcdf7cd1910922db55af7eb"
    sha256 cellar: :any_skip_relocation, monterey:       "251c273199fcd2965c0b1b3e85cfed5fcdc7eb5cfeaeeceae5d976078177cbc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "938715d30def6672c8c2783e34cbf4021fe667f2f9fcd4b529202f4077d9a387"
    sha256 cellar: :any_skip_relocation, catalina:       "5855139986b8826f4dd8ea671aa4da0cc6319be2b08d2b245d264195db5077b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80879633e2aef94bfcd75c387ed10f126d0cf22ca4d299a0be565036929c5ad8"
  end

  depends_on "ant" => :build # remove when switching to Jar url
  depends_on "graphviz"
  depends_on "openjdk"

  patch :DATA

  def install
    system "ant", "dist"
    jar = "plantuml.jar"
    libexec.install jar
    (bin/"plantuml").write <<~EOS
      #!/bin/bash
      if [[ "$*" != *"-gui"* ]]; then
        VMARGS="-Djava.awt.headless=true"
      fi
      GRAPHVIZ_DOT="#{Formula["graphviz"].opt_bin}/dot" exec "#{Formula["openjdk"].opt_bin}/java" $VMARGS -jar #{libexec}/#{jar} "$@"
    EOS
    chmod 0755, bin/"plantuml"
  end

  test do
    system bin/"plantuml", "-testdot"
  end
end

__END__
diff --git a/src/net/sourceforge/plantuml/cucadiagram/dot/GraphvizUtils.java b/src/net/sourceforge/plantuml/cucadiagram/dot/GraphvizUtils.java
index faebb12..95f0696 100644
--- a/src/net/sourceforge/plantuml/cucadiagram/dot/GraphvizUtils.java
+++ b/src/net/sourceforge/plantuml/cucadiagram/dot/GraphvizUtils.java
@@ -195,12 +195,12 @@ public class GraphvizUtils {
 		if (s == null) {
 			return -1;
 		}
-		final Pattern p = Pattern.compile("\\s([12].\\d\\d)\\D");
+		final Pattern p = Pattern.compile("\\s([123])\\.(\\d\\d?)\\D");
 		final Matcher m = p.matcher(s);
 		if (m.find() == false) {
 			return -1;
 		}
-		return Integer.parseInt(m.group(1).replaceAll("\\.", ""));
+		return 100 * Integer.parseInt(m.group(1)) + Integer.parseInt(m.group(2));
 	}
 
 	public static int getDotVersion() throws IOException, InterruptedException {
