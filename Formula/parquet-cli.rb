class ParquetCli < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https://parquet.apache.org/"
  url "https://github.com/apache/parquet-mr.git",
      tag:      "apache-parquet-1.12.3",
      revision: "f8dced182c4c1fbdec6ccb3185537b5a01e6ed6b"
  license "Apache-2.0"
  head "https://github.com/apache/parquet-mr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a411057efdb1d471ba0f7da8c4c81ec3bd32cb9f68b51dfceec5dd67d1f3adf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "feb0ac58cc6e7cebfb4c8f999bebe8821fb53e6d48a5674f0cb541c6c1f88608"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4738900ccf09ed266e176b4bf5984c61c5c083bf4547c13d7caf403ae6146d4"
    sha256 cellar: :any_skip_relocation, ventura:        "802880c473564959939d9e3c9ee5983fb9cf0f68fc5c8788796946c04fdd819d"
    sha256 cellar: :any_skip_relocation, monterey:       "37c3f5ba078794608d2b1402cfdef42414b16151636ace59b2b52a5160df1a68"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce0a8a0b97818bda0f82a331dde7dbbfa8f5cd2e5143fa8514a494ab217b5e91"
    sha256 cellar: :any_skip_relocation, catalina:       "18105bc4181c1a29479b9b62ec8d884f0e9f9425bbb6b30606bb8dea9b7fdd61"
  end

  depends_on "maven" => :build

  # parquet-cli has problems running on Linux, for more information:
  # https://github.com/Homebrew/homebrew-core/pull/94318#issuecomment-1049229342
  depends_on :macos

  depends_on "openjdk"

  # This file generated with `red-parquet` gem:
  #   Arrow::Table.new("values" => ["foo", "Homebrew", "bar"]).save("homebrew.parquet")
  resource("test-parquet") do
    url "https://gist.github.com/bayandin/2144b5fc6052153c1a33fd2679d50d95/raw/7d793910a1afd75ee4677f8c327491f7bdd2256b/homebrew.parquet"
    sha256 "5caf572cb0df5ce9d6893609de82d2369b42c3c81c611847b6f921d912040118"
  end

  # Patches snappy to 1.1.8.3 for MacOS arm64 support, won't be needed in >= 1.13.0
  # See https://issues.apache.org/jira/browse/PARQUET-2025
  #
  # We're using locally patch data because parquet-cli/pom.xml is linked to parquet-hadoop project
  # remotely, which depends on a bad version of snappy-java, so we need to add a direct dependency
  # from parquet-cli/pom.xml to snappy-java 1.1.8.3, which overrides the dependency version given
  # from parquet-hadoop.
  #
  patch :DATA

  def install
    cd "parquet-cli" do
      system "mvn", "clean", "package", "-DskipTests=true"
      system "mvn", "dependency:copy-dependencies"
      libexec.install "target/parquet-cli-#{version}-runtime.jar"
      libexec.install Dir["target/dependency/*"]
      (bin/"parquet").write <<~EOS
        #!/bin/sh
        set -e
        exec "#{Formula["openjdk"].opt_bin}/java" -cp "#{libexec}/*" org.apache.parquet.cli.Main "$@"
      EOS
    end
  end

  test do
    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet cat #{testpath}/homebrew.parquet")
    assert_match "{\"values\": \"Homebrew\"}", output
  end
end

__END__
diff --git a/parquet-cli/pom.xml b/parquet-cli/pom.xml
index 379e81b4e..96ea4d161 100644
--- a/parquet-cli/pom.xml
+++ b/parquet-cli/pom.xml
@@ -96,6 +96,11 @@
       <version>${hadoop.version}</version>
       <scope>provided</scope>
     </dependency>
+    <dependency>
+     <groupId>org.xerial.snappy</groupId>
+     <artifactId>snappy-java</artifactId>
+     <version>1.1.8.3</version>
+    </dependency>
   </dependencies>
 
   <build>
