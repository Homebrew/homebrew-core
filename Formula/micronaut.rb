class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.0.0.tar.gz"
  sha256 "5e30fc1878c9d7da9046745a5f71c611fc9bd1b765e32dd5e597a6fae1739f6c"

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "build"
    (bin/"mn").write_env_script libexec/"bin/mn", :JAVA_HOME => "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
