class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "http://micronaut.io"
  url "https://github.com/micronaut-projects/micronaut-core/releases/download/v1.0.0.M3/micronaut-1.0.0.M3.zip"
  version "1.0.0.M3"
  sha256 "394a315d0eeeb567b41a3ddfb9cad374e7b934ac9ba69ffb53fa38d0ea355e79"

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
