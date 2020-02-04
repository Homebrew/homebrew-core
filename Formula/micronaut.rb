class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-core/releases/download/v1.3.1/micronaut-1.3.1.zip"
  sha256 "af992cc2ca74f7893c6dde8f43abbc5ea7962ea23f3b1bb1ba77cb5e908fedbf"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %W[bin media cli-#{version}.jar]
    (bin/"mn").write_env_script libexec/"bin/mn", :JAVA_HOME => "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
