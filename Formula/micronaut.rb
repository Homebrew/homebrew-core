class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.1.3.tar.gz"
  sha256 "c4bbbbb9758b0fdadc1e1f1c4b28426d9a0cc750caa1a18086fd66c5e8d425dc"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/micronaut-projects/micronaut-starter/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f9052ade95a7e5e61bd41e644c6338a73d50c1e0ab5acb3c21119b167b4f77fe" => :catalina
    sha256 "0ded7aeb14d5c3ec80fc9d115fbf1b4c5f0713cbddb574765efc03de5ac1daad" => :mojave
    sha256 "456fa73c4bb0da5adfef273e11a50b42eed60b9e751c9aac56caf2103ebd1df7" => :high_sierra
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "micronaut-cli:assemble", "-x", "test"

    mkdir_p libexec/"bin"
    mv "starter-cli/build/exploded/bin/mn", libexec/"bin/mn"
    mv "starter-cli/build/exploded/lib", libexec/"lib"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
