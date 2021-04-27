class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.4.3.tar.gz"
  sha256 "0d12594e2412c1dba9c40aa92045df701158c7cd39789685e49ab4081efd6480"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "6bd52d53099de814d99fc5918c8f5ed5aef17f98d0fc869e708b5ec3154791fc"
    sha256 cellar: :any_skip_relocation, catalina: "6c3fbab1729010f101c228452f09d9dfd4c280696ec5e3c03d68024c5edc39e8"
    sha256 cellar: :any_skip_relocation, mojave:   "c80e5c70b0b3aa9aca560dba62410eee0fd931b5ad6b4175a2b337c25a3f9934"
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
