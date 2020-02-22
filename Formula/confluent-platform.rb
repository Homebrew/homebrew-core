class ConfluentPlatform < Formula
  desc "Developer-optimized distribution of Apache Kafka"
  homepage "https://www.confluent.io/product/confluent-platform/"
  url "https://packages.confluent.io/archive/5.4/confluent-5.4.0-2.12.tar.gz"
  version "5.4.0"
  sha256 "2d678d21a17dcbe99e2227519c7f60c02c51043cb8d6f90c75cc849d0782da52"

  bottle :unneeded

  depends_on :java => "1.8"

  conflicts_with "kafka", :because => "kafka also ships with identically named Kafka related executables"

  patch :DATA

  def install
    prefix.install "bin"
    rm_rf "#{bin}/windows"
    prefix.install "etc"
    prefix.install "share"
    prefix.install "libexec"
    rm_rf "#{libexec}/cli/linux_386"
    rm_rf "#{libexec}/cli/linux_amd64"
    rm_rf "#{libexec}/cli/windows_386"
    rm_rf "#{libexec}/cli/windows_amd64"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kafka-broker-api-versions --version")
  end
end
__END__
diff --git a/bin/confluent b/bin/confluent
index 1247e4f..fadbb8d 100755
--- a/bin/confluent
+++ b/bin/confluent
@@ -184,7 +184,8 @@ BINARY=confluent
 OS=$(uname_os)
 ARCH=$(uname_arch)
 PREFIX="${OWNER}/${REPO}"
-EXE_PATH="${BASH_SOURCE%/*}/../libexec/cli"
+SELF=$(realpath "${BASH_SOURCE}")
+EXE_PATH="${SELF%/*}/../libexec/cli"
 PLATFORM="${OS}/${ARCH}"

 # use in logging routines
