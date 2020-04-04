class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-core/releases/download/v1.3.4/micronaut-1.3.4.zip"
  sha256 "0a02d9b49b8a41b00fdeb55f4a62664b8aff6f63a1785acbcff1695451551724"

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
