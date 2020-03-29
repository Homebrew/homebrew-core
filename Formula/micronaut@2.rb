class MicronautAT2 < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-core/releases/download/v2.0.0.M1/micronaut-2.0.0.M1.zip"
  version "2.0.0.M1"
  sha256 "4a02f27bcc9c0165781b050fe75245d8843000dc4c25a76ba34dcd830b0943c3"

  bottle :unneeded

  keg_only :versioned_formula

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
