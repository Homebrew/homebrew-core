class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-core/releases/download/v1.2.3/micronaut-1.2.3.zip"
  sha256 "313af68543211d4ed6e914e216b6a5343d23238111de4c14ea5008b1f5f11bb0"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %W[bin media cli-#{version}.jar]
    bin.install_symlink libexec/"bin/mn"
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
