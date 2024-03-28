class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/archive/refs/tags/2.11.2.tar.gz"
  sha256 "0e078b37fe1ba1a9ca7191e706818e3b423588cac55484dda82dbbd1cdfe0b24"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2b5e7f40c765e5d93606a361389c7d3b0a527472dbb4c8e048ee681365c69fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95769cbff07c37a67f0639fc6aa9bb07b975c6190ee522be0ac9357285023112"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d71fbca8a5b1a0b7e1dc1fb0247104e7a7420d90bdf5a151eb61159354e02f5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7e35e73999181f89bb33090ac3bb978f7e928950bf8262d2b3a02c51e0aaeed"
    sha256 cellar: :any_skip_relocation, ventura:        "98620344224df5447fb46d0bddf1aaa0bfbbc721eebd5e4b80293af1d7f40d99"
    sha256 cellar: :any_skip_relocation, monterey:       "97b3509b2a1ece5cbea662087610a552592535f5a690599ce24f1058562b2070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "498b341805351d474054b683fdeec977694b1ecc5f715b304376a94a19af23c2"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  # gradle 8 build patch, remove in next release
  patch :DATA

  def install
    ENV["CIRCLE_TAG"] = version
    ENV["GROOVY_SSH_VERSION"] = version
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "cli/build/libs/gssh.jar"
    bin.write_jar_script libexec/"gssh.jar", "gssh"
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
