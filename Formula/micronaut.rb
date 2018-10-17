class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "http://micronaut.io"
  url "https://github.com/micronaut-projects/micronaut-core/releases/download/v1.0.0.RC3/micronaut-1.0.0.RC3.zip"
  sha256 "c3d1b423a7e2d1bec12524925418a614c80050dbc390b6542f280f301ba02932"

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
