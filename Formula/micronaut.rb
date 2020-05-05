class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.0.0.RC1.tar.gz"
  sha256 "91dc71b200c598a91b95a20792dcc3f3cb160b8e169b581f6b98689dc713acad"

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "build"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
