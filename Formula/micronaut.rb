class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "http://micronaut.io"
  url "https://github.com/micronaut-projects/micronaut-core/releases/download/v1.0.0/micronaut-1.0.0.zip"
  sha256 "b7ea06e1382a3c030d0bdbece16b2bc899610d0f58d257f65af69a4a3ef115cb"

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
