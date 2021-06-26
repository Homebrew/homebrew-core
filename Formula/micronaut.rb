class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.5.7.tar.gz"
  sha256 "5fce4ec749ef894138c29a74443dc145998f295313f7ce15fcc28933ef4656e6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "8752ff18522e1880924b31229392f020fdc39c5583964c9c93358e86598762ec"
    sha256 cellar: :any_skip_relocation, catalina: "560ca9a9c949b43e60dc1a75bd972870d8756d6cdbc34d324d572e7e8d146a98"
    sha256 cellar: :any_skip_relocation, mojave:   "c8a99c0394d59af7dc97a47e2b0deeec3c7534d10b42218122797d03aa95e6c6"
  end

  if Hardware::CPU.arm?
    depends_on "openjdk@11"
  else
    depends_on "openjdk"
  end

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
