class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.1.4.tar.gz"
  sha256 "9f4b736ab2fcd4578d44217bc5fbf3662036571284e5deb4c1e390a1170f2166"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/micronaut-projects/micronaut-starter/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "40391f6a51c8969d58f46997473b375e695de3eb0591234d7bae4230bdee73fd" => :big_sur
    sha256 "90d257248fcf1dff368267b9d308359c9b3b92f37016b6e61c28433a2e7f9b61" => :catalina
    sha256 "89bdc8de1357bbe6854514428c2ce31026fd6c0b065f8a2de97f0886bdb01d23" => :mojave
    sha256 "6396694f7db336011e56582ffe6d16c8cbafaeded441385014f810b4483e3325" => :high_sierra
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
