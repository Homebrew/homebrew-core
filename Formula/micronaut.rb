class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.5.5.tar.gz"
  sha256 "d40fadba548df087c57919ac8ad685624ad39e3add2fad8e52d2af1912c68815"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "c0b1768ca7cfca0affcd1d899546ed1a5711dbc7d585620e94f972451609fee0"
    sha256 cellar: :any_skip_relocation, catalina: "f68adbee84c552cfb5bc4b5fc63a49dcfca6949aa1f5b21e6eae7b8339bd5df9"
    sha256 cellar: :any_skip_relocation, mojave:   "1a700958ff2cd4e563480860d487aea05af460794b1c8ecfd718d840773dbe3a"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "./gradlew", "micronaut-cli:assemble", "-x", "test"

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
