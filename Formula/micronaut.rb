class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "http://micronaut.io"
  url "https://github.com/micronaut-projects/micronaut-core/releases/download/v1.0.1/micronaut-1.0.1.zip"
  sha256 "960c744565bbf6b7dc34b2fbaaa8273b13c5f2f7c1b31d922de1ccd25c9295dc"

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
