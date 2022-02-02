class ParquetCli < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https://parquet.apache.org/"
  url "https://github.com/apache/parquet-mr.git",
      tag:      "apache-parquet-1.12.0",
      revision: "db75a6815f2ba1d1ee89d1a90aeb296f1f3a8f20"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/parquet-mr.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0534ab800669ce2048ff05409d7b6568df34bf7aa6507fc2e4417da8418ba89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2047e61a6366122dde6a70c01f49b464d16fb4a044ab949278ff0e4cc37e735"
    sha256 cellar: :any_skip_relocation, monterey:       "25a014f843a9ccd2d1b3e715d8dcf2ffe6b24bcfa0bc78739d1b1caf3529e1e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "9140045b83453b50a13384917993e14068d48285ba4410c09d22347f2c00f9be"
    sha256 cellar: :any_skip_relocation, catalina:       "b522b0d1481308650dac17bc1e4b7fab207a501038e663d41ee9d11a535288ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3d896f727c127f43d5e0d476f3f9b7d314f96aada084846d3659eab7e1d200a"
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
