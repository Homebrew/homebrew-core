class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-core/releases/download/v1.2.1/micronaut-1.2.1.zip"
  sha256 "1493511d92fcf8c26849c25dab8e79b63a24ff05fc943dc3945c1d3529fb8751"

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
