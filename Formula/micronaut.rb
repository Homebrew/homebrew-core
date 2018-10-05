class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "http://micronaut.io"
  url "https://github.com/micronaut-projects/micronaut-core/releases/download/v1.0.0.RC1/micronaut-1.0.0.RC1.zip"
  sha256 "c133eed12e9b59efab7aa8522f0b2dc9a24876fb36aa7077faf2f8e8a4e8c66c"

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
