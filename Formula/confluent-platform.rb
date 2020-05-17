class ConfluentPlatform < Formula
  desc "Developer-optimized distribution of Apache Kafka"
  homepage "https://www.confluent.io/product/confluent-platform/"
  url "https://packages.confluent.io/archive/5.4/confluent-5.4.1-2.12.tar.gz"
  version "5.4.1"
  sha256 "3a0fb84e9b22f91eead27490840c2c21d79778ecf1c69ae9d8bbe44ee0f5e48b"

  bottle :unneeded

  depends_on :java => "1.8"

  conflicts_with "kafka", :because => "kafka also ships with identically named Kafka related executables"

  patch :p0, :DATA

  def install
    libexec.install %w[bin etc libexec share]
    rm_rf libexec/"bin/windows"

    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output("#{bin}/kafka-broker-api-versions --version")

    # The executable "confluent" tries to create .confluent under the home directory
    # without considering the envrionment variable "HOME", so the execution will fail
    # due to sandbox-exec.
    # The message "unable to load config" means that the execution will succeed
    # if the user has write permission.
    err, = Open3.capture2e("#{bin}/confluent")
    assert_match /\Aunable to load config/, err

    assert_match /usage: confluent-hub/, shell_output("#{bin}/confluent-hub help")
  end
end

__END__
--- bin/confluent-hub.orig	2020-03-03 08:53:14.000000000 +0900
+++ bin/confluent-hub	2020-05-18 03:57:04.000000000 +0900
@@ -4,11 +4,6 @@
 
 base_dir=$(dirname $0)
 
-if [ -L /usr/local/bin/confluent-hub ]; then
-    #brew cask installation
-    base_dir=$(dirname $( ls -l /usr/local/bin/confluent-hub | awk '{print $11}' ))
-    #base_dir refers to Caskrooom/confluent-hub-client
-fi
 #cd -P deals with symlink from /bin to /usr/bin
 java_base_dir=$( cd -P "$base_dir/../share/java" && pwd )
 HUB_CLI_CLASSPATH="${HUB_CLI_CLASSPATH}:${java_base_dir}/confluent-hub-client/*"
