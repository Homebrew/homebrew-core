class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/archive/refs/tags/2.11.2.tar.gz"
  sha256 "0e078b37fe1ba1a9ca7191e706818e3b423588cac55484dda82dbbd1cdfe0b24"
  license "Apache-2.0"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "908725192316eb3e9c9d54688d6233261998fc248c0196d5c518fc504ee5ec79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fee6aa3a10a6bc1427d48fcd271b055a8c7f4f7fedc7164519e2be8b7aa81b98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "701b4eb639074e1e7b39d3358531836bf142f3751123145e701aaa71fd17cb03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f5ed2374501abd977eb5c67490489ebe7354094c48f878d01543bd3d69a8782"
    sha256 cellar: :any_skip_relocation, sonoma:         "966fffd78fe61b7292a4141678a84e3a700a9388ecb2ab04ef2daba8220ccc5f"
    sha256 cellar: :any_skip_relocation, ventura:        "2b1130e6167fd512b87c843e1ebe20830b95bb21e98469cd681a944897300c61"
    sha256 cellar: :any_skip_relocation, monterey:       "1b51f981f8523077dbc4ac4269267ef57fc4c38d3c015bac0e14e1f612044f16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db58030c9483c22ecde1258a00dd0bd3f1da7649e1114178e0495e0195296ef6"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@21"

  # gradle 8 build patch, remove in next release
  patch :DATA

  def install
    ENV["CIRCLE_TAG"] = version
    ENV["GROOVY_SSH_VERSION"] = version
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "cli/build/libs/gssh.jar"
    bin.write_jar_script libexec/"gssh.jar", "gssh", java_version: "21"
  end

  test do
    assert_match "groovy-ssh-#{version}", shell_output("#{bin}/gssh --version")
  end
end

__END__
diff --git a/cli/build.gradle b/cli/build.gradle
index 8044c6e..e6c2815 100644
--- a/cli/build.gradle
+++ b/cli/build.gradle
@@ -32,7 +32,7 @@ jar {
 }

 shadowJar {
-    baseName = 'gssh'
-    classifier = ''
-    version = ''
+    archiveBaseName = 'gssh'
+    archiveVersion = ''
+    archiveClassifier = ''
 }
