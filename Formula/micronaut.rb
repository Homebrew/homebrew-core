class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.3.0.tar.gz"
  sha256 "5ac1f74c550a82e2858ea29f50f1130178bd458554c1785e4a443318a8576f0f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cccaa88368b8d41d146e6443a53cfc3e3390fedc979eab1a29ea1ea32820ff1d" => :big_sur
    sha256 "d9df29145e370ea0b4111f6014779657ed211f10990b21672ff46dfd295b7490" => :catalina
    sha256 "0fe0b1aa763a58e8958664f4ae5b70cb34cf6c39e85354a7584fbbc248959cbe" => :mojave
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
